return {
	Analytics = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics"),
	EditDisplayNameErrorModal = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/ErrorModals/EditDisplayNameErrorModal"),
	EditSocialNetworksErrorModal = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/ErrorModals/EditSocialNetworksErrorModal"),
	UsernameInsufficientFundsModal = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/ErrorModals/UsernameInsufficientFundsModal"),
	EditSocialLinksModal = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/EditSocialLinksModal"),
	Flags = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags"),
	Constants = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Constants"),
	installReducer = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/installReducer"),
	RoduxKey = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Constants").RODUX_KEY,
	EditUsernameWrapper = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/EditUsernameWrapper"),
	useDisplayNameText = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Hooks/useDisplayNameText"),
	Enums = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Enums"),
	EditProfileScreenViewAdapter = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/EditProfileScreenViewAdapter"),
	EditProfileLanding = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/EditProfileLanding"),
	EditProfileToastScreen = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/EditProfileToast")
}
