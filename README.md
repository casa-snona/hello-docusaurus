# Hello Docusaurus

[カサレアル Advent Calendar 2022](https://qiita.com/advent-calendar/2022/casareal) 向けのサンプルコードです。<br>
次の記事とともにご使用ください。

* [VSCode + Docusaurus で最高のドキュメント作成環境を構築する](https://zenn.dev/casa_snona/articles/vscode-docusaurus-local-env)
* [Docusaurus で作成するドキュメントはココがいいね！](https://zenn.dev/casa_snona/articles/docusaurus-is-good-here)
* [Nginx + Docusaurus でドキュメントをコンテナ化してみる](https://zenn.dev/casa_snona/articles/containerize-docusaurus)
* [Nginx + OAuth2 Proxy で静的 Web サイトに認証機能を追加してみる](https://zenn.dev/casa_snona/articles/nginx-with-oauth2-proxy)
* [静的 Web サイトに認証をつけて AWS App Runner でデプロイしてみる](https://zenn.dev/casa_snona/articles/deploy-static-website-with-aws-app-runner)

## 使い方

`.devcontainer` を配置しているので、VSCode の Dev Containers 拡張機能を使って起動してください。（前提条件として、Docker デーモンが起動している必要があります）

## Docusaurus のプレビュー

Docusaurus のワークディレクトリに移動。

```bash
cd my-website/
```

必要なパッケージ群をインストール。

```bash
npm install
```

Docusaurus を起動して、`http://localhost:3000` にアクセス。

```bash
npm run start
```

## コンテナイメージの作成とコンテナ起動

Docker ビルドを実施。

```bash
DOCKER_BUILDKIT=1 docker build --progress=plain --no-cache -t my-website:1.0.0 .
```

コンテナを起動。

```bash
docker run --rm -p 80:80 \
  --env COOKIE_SECRET=`python3 -c 'import os,base64; print(base64.urlsafe_b64encode(os.urandom(32)).decode())'` \
  --env USER_POOL_ID=xxxxxxxxxxxxxx_xxxxxxxxx \
  --env APPLICATION_CLIENT_ID=xxxxxxxxxxxxxxxxxxxxxxxxxx \
  --env APPLICATION_CLIENT_SECRET=*************************************************** \
  --env REDIRECT_URL=http://localhost/oauth2/callback \
  my-website:1.0.0
```

環境変数は次の通り。

| 環境変数                  | 設定値                                                   |
| :------------------------ | :------------------------------------------------------- |
| COOKIE_SECRET             | Cookie のシード文字列                                    |
| USER_POOL_ID              | Cognito のユーザープール ID                              |
| APPLICATION_CLIENT_ID     | Cognito のアプリケーションクライアント ID                |
| APPLICATION_CLIENT_SECRET | Cognito のアプリケーションクライアントのシークレット     |
| REDIRECT_URL              | Cognito のアプリケーションクライアントのコールバック URL |
