local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local PublishConfigurationContentContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PublishConfigurationContent/PublishConfigurationContentContainer")
local PublishFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/PublishFooter/PublishFooter")
local PublishLatestPreviewCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/PublishPreviewCard/PublishLatestPreviewCard")
local PublishPreviewCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/PublishPreviewCard/PublishPreviewCard")
local PublishStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/PublishStatus")
local useScrollPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/useScrollPerformanceTracker")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")
local FFlagBuildExperienceConfigurationRowTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceConfigurationRowTelemetry")

local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View

local function PublishPreview(p2)
	local loading = useLocalization({ loading = LocalizationStrings.BUILD_MENU_LOADING }).loading
	local v5 = if PublishStatus.usePublishStatus(p2.target).isPublishLatest then PublishLatestPreviewCard else PublishPreviewCard
	local target = p2.target

	return React.createElement(v5, {
		target = {
			universeId = target.universeId,
			placeId = target.placeId,
			experienceName = target.experienceName or loading,
			creatorName = target.creatorName,
			gameIcon = target.gameIcon
		},
		isCreatorVerified = target.isCreatorVerified,
		layoutOrder = 1
	})
end

local function PublishSheetContent(p2)
	useScrollPerformanceTracker("LuaApp_Build_PublishSheet_Scroll", p2.scrollingFrameRef)

	return React.createElement(sheet.Content, {
		scrollingFrameRef = p2.scrollingFrameRef
	}, p2.children)
end

local function PublishBottomSheet(props)
	local publish = useLocalization({ publish = LocalizationStrings.BUILD_MENU_PUBLISH }).publish
	local testId = props.testId or "publish-bottom-sheet"
	local ref = React.useRef(nil)

	local createElement = React.createElement
	local root = sheet.Root
	local v5 = {
		isOpen = props.isOpen,
		snapPoints = { 0.75, 1 },
		defaultSnapPointIndex = 2,
		onClose = props.onClose,
		testId = testId
	}

	local children = {
		Header = React.createElement(sheet.Header, { hasCloseAffordance = true }, {
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Text = publish,
				tag = "shrink auto-xy text-heading-small text-wrap text-align-x-left content-emphasis"
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	local v11 = {
		Preview = React.createElement(PublishPreview, { target = props.target }),
		Configuration = 0
	}

	local createElement4 = React.createElement
	local v13 = {
		universeId = props.target.universeId,
		placeId = 0,
		sessionId = 0,
		onOpenTitleDescriptionPage = 0,
		onOpenMediaSelectionPage = 0,
		onOpenVersionTitleDescriptionPage = 0,
		onOpenVersionHistory = 0,
		isNewGame = 0,
		layoutOrder = 2
	}
	local v14 = if FFlagBuildExperienceConfigurationRowTelemetry then props.target.placeId else nil
	v13.placeId = v14
	local v15 = if FFlagBuildExperienceConfigurationRowTelemetry then props.target.sessionId else nil
	v13.sessionId = v15
	v13.onOpenTitleDescriptionPage = props.onOpenTitleDescriptionPage
	v13.onOpenMediaSelectionPage = props.onOpenMediaSelectionPage
	v13.onOpenVersionTitleDescriptionPage = props.onOpenVersionTitleDescriptionPage
	v13.onOpenVersionHistory = props.onOpenVersionHistory
	local v16 = if FFlagBuildCheckGamePermissions then props.target.isNewGameTarget else nil
	v13.isNewGame = v16
	v11.Configuration = createElement4(PublishConfigurationContentContainer, v13)
	children.Content = createElement2(PublishSheetContent, { scrollingFrameRef = ref }, {
		Body = createElement3(view, { tag = "col gap-large size-full-0 auto-y" }, v11)
	})

	local createElement5 = React.createElement
	local actions = sheet.Actions
	local createElement6 = React.createElement
	local v21 = {
		universeId = props.target.universeId,
		placeId = props.target.placeId,
		sessionId = props.target.sessionId,
		isNewGameTarget = 0
	}
	local v22 = if FFlagBuildCheckGamePermissions then props.target.isNewGameTarget else nil
	v21.isNewGameTarget = v22
	children.Actions = createElement5(actions, nil, {
		Footer = createElement6(PublishFooter, {
			target = v21,
			testId = testId,
			showPreviewButton = props.showPreviewButton,
			onPreview = props.onClose
		})
	})
	return createElement(root, v5, children)
end

return PublishBottomSheet
