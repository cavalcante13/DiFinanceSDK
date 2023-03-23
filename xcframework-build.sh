#!/bin/sh

######################
# Globals
######################

# Avilable Platforms/Architectures
# macosx | iphoneos | iphonesimulator | appletvos | appletvsimulator | watchos | watchsimulator

setupVariables()
{
    # Local .env
    if [ -f .env ]; then
        # Load Environment Variables
        export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
    fi

    # set framework name or read it from project by this variable
    FRAMEWORK_NAME="$(echo $FRAMEWORK_NAME)"
    # set base dir
    BASE_DIR="$(pwd)"
    # set workspace path
    WORKSPACE_PATH="${BASE_DIR}/${FRAMEWORK_NAME}.xcworkspace"
    # set framework folder name
    FRAMEWORK_FOLDER_NAME="${FRAMEWORK_NAME}_XCFramework"
    #xcframework folder path
    FRAMEWORK_FOLDER_PATH="${BASE_DIR}/${FRAMEWORK_FOLDER_NAME}"
    #xcframework path
    FRAMEWORK_PATH="${BASE_DIR}/${FRAMEWORK_NAME}.xcframework"
    # set path for iOS simulator archive
    SIMULATOR_ARCHIVE_PATH="${FRAMEWORK_FOLDER_PATH}/simulator.xcarchive"
    # set path for iOS device archive
    IOS_DEVICE_ARCHIVE_PATH="${FRAMEWORK_FOLDER_PATH}/iOS.xcarchive"

    SUCCESS=true
    EXIT_MESSAGE=$?
    ROW_STRING="\n##################################################################\n"
}

echoPaths()
{
    echo "${ROW_STRING}"
    echo "FRAMEWORK_PATH: ${FRAMEWORK_PATH}"
    echo "SIMULATOR_ARCHIVE_PATH: ${SIMULATOR_ARCHIVE_PATH}"
    echo "IOS_DEVICE_ARCHIVE_PATH: ${IOS_DEVICE_ARCHIVE_PATH}"
    echo "${ROW_STRING}"
}

checkSuccess()
{
    if [[ -z $EXIT_MESSAGE ]]; then
        SUCCESS=false
        exitWithMessage
        exit 1
    fi
}

exitWithMessage()
{
    echo "${ROW_STRING}"

    if [ "$SUCCESS" = true ] ; then
        echo "\n\n\n 🏁 Completed with Success! 🙂"
    else
        echo "\n\n\n 😱 Completed with Errors! Please check line above for details:"
        echo "${EXIT_MESSAGE}"
    fi
    echo "\n 🔍 For more details you can always check the /tmp/${FRAMEWORK_NAME}_archive.log file. 📝 \n\n\n"
    echo "${ROW_STRING}"
}

createTempFolders()
{
    rm -rf "${FRAMEWORK_FOLDER_PATH}"

    rm -rf "${FRAMEWORK_PATH}"

    echo "Deleted ${FRAMEWORK_FOLDER_NAME} and ${FRAMEWORK_PATH}"

    mkdir "${FRAMEWORK_FOLDER_PATH}"

    echo "Created ${FRAMEWORK_FOLDER_NAME}"
}

removeTempFiles()
{
    rm -rf "${FRAMEWORK_FOLDER_PATH}"
    # rm -rf "${SIMULATOR_ARCHIVE_PATH}"
    # rm -rf "${IOS_DEVICE_ARCHIVE_PATH}"
}

######################
######################
######################


######################
# Starting the logging
######################

exec > /tmp/${FRAMEWORK_NAME}_archive.log 2>&1
open /tmp/${FRAMEWORK_NAME}_archive.log
echo "\n ⏱ Starting the XCFramework build... \n\n\n"

######################
# Setup Variables
######################

setupVariables

######################
# Echo the PATHS
######################

echoPaths

######################
# Make sure the output directory exists
######################

createTempFolders

######################
# Step 1: Build Frameworks
######################

echo "${ROW_STRING}"
echo "\n\n\n 🚀 Step 1-1: Building for iOS Simulator \n\n\n"
echo "${ROW_STRING}"

EXIT_MESSAGE="$(xcodebuild archive -workspace "${WORKSPACE_PATH}" -scheme "${FRAMEWORK_NAME}" -archivePath "${SIMULATOR_ARCHIVE_PATH}" -sdk iphonesimulator SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES)"

checkSuccess
echo "${ROW_STRING}"


echo "${ROW_STRING}"
echo "\n\n\n 🚀 Step 1-2: Building for iOS Device \n\n\n"
echo "${ROW_STRING}"

EXIT_MESSAGE="$(xcodebuild archive -workspace "${WORKSPACE_PATH}" -scheme "${FRAMEWORK_NAME}" -archivePath "${IOS_DEVICE_ARCHIVE_PATH}" -sdk iphoneos SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES)"

checkSuccess
echo "${ROW_STRING}"


######################
# Step 2. Create the XCFramework
######################

echo "${ROW_STRING}"
echo "\n\n\n 📦 Step 2: Create the XCFramework \n\n\n"
echo "${ROW_STRING}"

EXIT_MESSAGE="$(xcodebuild -create-xcframework -framework ${SIMULATOR_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework -framework ${IOS_DEVICE_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework -output ${FRAMEWORK_PATH})"

checkSuccess
echo "${ROW_STRING}"


######################
# Step 3. Removing temp folders
######################

echo "${ROW_STRING}"
echo "\n\n\n 🧹 Step 3: Removing temp folders \n\n\n"
echo "${ROW_STRING}"

removeTempFiles
echo "${ROW_STRING}"


######################
# Step 6. Open the framework's directory
######################

echo "${ROW_STRING}"
# open "${FRAMEWORK_FOLDER_PATH}"
echo "${ROW_STRING}"



######################
# Step 7. Open the log file on Console application
######################

exitWithMessage
