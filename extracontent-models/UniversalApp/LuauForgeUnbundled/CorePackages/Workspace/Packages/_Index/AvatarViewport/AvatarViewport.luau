require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Types")

return {
	CameraMath = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/CameraMath"),
	Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Constants"),
	ModelSources = {
		fromUserId = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/ModelSources/createUserIdModelSource"),
		fromUserIdWithRigType = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/ModelSources/createUserIdRigTypeModelSource")
	},
	useRotatableOrbitViewport = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Hooks/useRotatableOrbitViewport"),
	useAvatarViewportScene = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Hooks/useAvatarViewportScene"),
	useViewportModelLoader = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Hooks/useViewportModelLoader"),
	useViewportOrbitInteractions = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Hooks/useViewportOrbitInteractions"),
	useViewportGamepadOrbit = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Hooks/useViewportGamepadOrbit"),
	useOrbitHeadCamera = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Hooks/useOrbitHeadCamera"),
	AvatarViewportScene = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Components/AvatarViewportScene"),
	ViewportInteractionOverlay = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Components/ViewportInteractionOverlay")
}
