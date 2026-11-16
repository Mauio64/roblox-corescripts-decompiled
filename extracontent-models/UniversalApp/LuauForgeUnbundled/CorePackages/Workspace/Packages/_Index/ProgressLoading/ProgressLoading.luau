local createLazyComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/RoactUtils").Components.createLazyComponent
require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Types")

return {
	Components = {
		Footer = createLazyComponent(function()
			return require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Components/Footer")
		end),
		TiltKeyart = createLazyComponent(function()
			return require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Components/TiltKeyart")
		end),
		TiltLockup = createLazyComponent(function()
			return require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Components/TiltLockup")
		end)
	},
	ProgressLoadingAssetsScreenGui = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/ProgressLoadingAssetsScreenGui")
	end),
	PreGameLoadingScreen = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/PreGameLoadingScreen")
	end),
	GetDeferredAssetStore = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Stores/GetDeferredAssetStore"),
	PregameOverride = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Stores/PregameOverride"),
	TiltLoadingScreen = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen")
	end),
	useLoadingScreenAnimation = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Hooks/useLoadingScreenAnimation"),
	LoadingScreenView = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenView")
	end),
	AutoTranslateBadge = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Components/AutoTranslateBadge")
	end),
	PolicyContainer = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Components/PolicyContainer")
	end),
	ServerStatus = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Components/ServerStatus")
	end),
	ServerStatusWithCountdown = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Components/ServerStatusWithCountdown")
	end),
	PlaceLauncherState = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Enums/PlaceLauncherState"),
	createNetworking = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/createNetworking")
}
