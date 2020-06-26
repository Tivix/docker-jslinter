FROM alpine:3.12 as builder

RUN set -eux \
	&& apk add --no-cache \
		nodejs-current \
		npm

ARG VERSION=7.2.0
RUN set -eux \
	&& npm install --production --remove-dev eslint@$VERSION \
	   @tivix/eslint-config \
	   @tivix/prettier-config \
	   @tivix/typescript-config \
	   @tivix/stylelint-config \
	   prettier \
	   eslint-plugin-prettier \
	   typescript \
	&& /node_modules/eslint/bin/eslint.js --version | grep -E '^v?[0-9]+'

# Remove unecessary files
RUN set -eux \
	&& find /node_modules -type d -iname 'test' -prune -exec rm -rf '{}' \; \
	&& find /node_modules -type d -iname 'tests' -prune -exec rm -rf '{}' \; \
	&& find /node_modules -type d -iname 'testing' -prune -exec rm -rf '{}' \; \
	&& find /node_modules -type d -iname '.bin' -prune -exec rm -rf '{}' \; \
	\
	&& find /node_modules -type f -iname '.*' -exec rm {} \; \
	&& find /node_modules -type f -iname 'LICENSE*' -exec rm {} \; \
	&& find /node_modules -type f -iname 'Makefile*' -exec rm {} \; \
	&& find /node_modules -type f -iname '*.bnf' -exec rm {} \; \
	&& find /node_modules -type f -iname '*.css' -exec rm {} \; \
	&& find /node_modules -type f -iname '*.def' -exec rm {} \; \
	&& find /node_modules -type f -iname '*.flow' -exec rm {} \; \
	&& find /node_modules -type f -iname '*.html' -exec rm {} \; \
	&& find /node_modules -type f -iname '*.info' -exec rm {} \; \
	&& find /node_modules -type f -iname '*.jst' -exec rm {} \; \
	&& find /node_modules -type f -iname '*.lock' -exec rm {} \; \
	&& find /node_modules -type f -iname '*.map' -exec rm {} \; \
	&& find /node_modules -type f -iname '*.markdown' -exec rm {} \; \
	&& find /node_modules -type f -iname '*.md' -exec rm {} \; \
	&& find /node_modules -type f -iname '*.mjs' -exec rm {} \; \
	&& find /node_modules -type f -iname '*.mli' -exec rm {} \; \
	&& find /node_modules -type f -iname '*.png' -exec rm {} \; \
	&& find /node_modules -type f -iname '*.yml' -exec rm {} \;

FROM alpine:3.12
LABEL \
	maintainer="Tivix <michal.kopacki@tivix.com>" \
	repo="https://github.com/tivix/docker-jslinter"
COPY docker-entrypoint.sh /
COPY --from=builder /node_modules/ /node_modules/
RUN set -eux \
	&& apk add --no-cache nodejs-current \
	&& ln -sf /node_modules/eslint/bin/eslint.js /usr/bin/eslint \
	&& ln -sf /node_modules/prettier/bin-prettier.js /usr/bin/prettier \
	&& ln -sf /node_modules/typescript/bin/tsc /usr/bin/tsc

WORKDIR /code
ENTRYPOINT ["/docker-entrypoint.sh"]