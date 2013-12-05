test:
	xcodebuild \
		-sdk iphonesimulator \
		-scheme XMMMFuture \
		-configuration Debug \
		clean build test
