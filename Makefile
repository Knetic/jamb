default: package

init:
	@rm -rf ./.output
	@mkdir -p ./.output

package: init versionCheck fpmCheck

	fpm \
		--log error \
		-s dir \
		-t deb \
		-v $(JAMB_VERSION) \
		-n jamb \
		./jamb.sh=/usr/local/bin/jamb

	@mv ./*.deb ./.output/

fpmCheck:
ifeq ($(shell which fpm), )
	@echo "FPM is not installed, no packages will be made."
	@echo "https://github.com/jordansissel/fpm"
	@exit 1
endif

versionCheck:
ifeq ($(JAMB_VERSION), )

	@echo "No 'JAMB_VERSION' was specified."
	@echo "Export a 'JAMB_VERSION' environment variable to perform a package"
	@exit 1
endif
