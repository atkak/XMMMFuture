PROJECT = XMMMFuture/XMMMFuture.xcodeproj
TEST_TARGET = XMMMFutureTests

clean:
	xcodebuild \
		-project $(PROJECT) \
		clean

test:
	xcodebuild \
		-sdk iphonesimulator \
		-scheme XMMMFuture \
		-configuration Debug \
		clean build test
