FLUTTER := $(shell which flutter)
FLUTTER_DIR := $(FLUTTER_BIN_DIR:/bin=)
DART := $(FLUTTER_BIN_DIR)/cache/dart-sdk/bin/dart

# # Obtain your API_KEY at https://localise.biz
# LOCALISE_KEY := ''
#
# SENTRY_AUTH_TOKEN := ''

MAX_LINE_LENGTH := 120

.PHONY: icon
icon:
	$(FLUTTER) pub run flutter_launcher_icons:main

.PHONY: splash
splash:
	$(FLUTTER) pub run flutter_native_splash:create

.PHONY: analyze
analyze:
	$(FLUTTER) analyze

.PHONY: format
format:
	$(FLUTTER) format -l $(MAX_LINE_LENGTH) .

.PHONY: test
test:
	$(FLUTTER) test

.PHONY: b-r
b-r:
	$(FLUTTER) packages pub run build_runner build --delete-conflicting-outputs

.PHONY: clean
clean:
	$(FLUTTER) clean
	$(FLUTTER) pub get

.PHONY: cleanf
cleanf:
	$(FLUTTER) clean
	$(FLUTTER) pub get
	$(FLUTTER) packages pub run build_runner build --delete-conflicting-outputs

.PHONY: i-clean
i-clean:
	$(FLUTTER) clean
	$(FLUTTER) pub get
	cd ios
	pod update
	cd ..

.PHONY: cocoa-pods-update
coco:
	cd ios
	sudo gem install cocoapods
	pod update

.PHONY: watch
watch:
	$(FLUTTER) packages pub run build_runner watch --delete-conflicting-outputs

.PHONY: l10n
l10n:
	$(FLUTTER) gen-l10n

.PHONY: l10n-sync
l10n-sync:
	./scripts/update-l10n.sh $(LOCALISE_KEY)
