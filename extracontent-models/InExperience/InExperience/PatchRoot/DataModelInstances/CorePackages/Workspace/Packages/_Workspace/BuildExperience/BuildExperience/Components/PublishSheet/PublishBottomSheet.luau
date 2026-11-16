local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local PublishConfigurationContentContainer = require(BuildExperience.Components.PublishConfigurationContent.PublishConfigurationContentContainer)
local PublishFooter = require(BuildExperience.Components.GameConfigurations.PublishFooter.PublishFooter)
local PublishLatestPreviewCard = require(BuildExperience.Components.GameConfigurations.PublishPreviewCard.PublishLatestPreviewCard)
local PublishPreviewCard = require(BuildExperience.Components.GameConfigurations.PublishPreviewCard.PublishPreviewCard)
local PublishStatus = require(BuildExperience.Chat.PublishStatus)
local useScrollPerformanceTracker = require(BuildExperience.Telemetry.useScrollPerformanceTracker)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)

local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View

local function PublishPreview(p)
	local loading = useLocalization({ loading = LocalizationStrings.BUILD_MENU_LOADING }).loading
	local v

	if PublishStatus.usePublishStatus(p.target).isPublishLatest then
		v = PublishLatestPreviewCard
	else
		v = PublishPreviewCard
	end

	local target = p.target

	return React.createElement(v, {
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

local function PublishSheetContent(p)
	useScrollPerformanceTracker("LuaApp_Build_PublishSheet_Scroll", p.scrollingFrameRef)

	return React.createElement(Sheet.Content, { scrollingFrameRef = p.scrollingFrameRef }, p.children)
end

local function PublishBottomSheet(props)
	local publish = useLocalization({ publish = LocalizationStrings.BUILD_MENU_PUBLISH }).publish
	local testId = props.testId or "publish-bottom-sheet"
	local ref = React.useRef(nil)

	local createElement = React.createElement
	local root = Sheet.Root
	local v = {
		isOpen = props.isOpen,
		snapPoints = { 0.75, 1 },
		defaultSnapPointIndex = 2,
		onClose = props.onClose,
		testId = testId
	}

	local children = {
		Header = React.createElement(Sheet.Header, { hasCloseAffordance = true }, {
			Title = React.createElement(Text, {
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

	local v2 = {
		Preview = React.createElement(PublishPreview, { target = props.target }),
		Configuration = 0
	}

	local createElement4 = React.createElement
	local v3 = {
		universeId = props.target.universeId,
		onOpenTitleDescriptionPage = props.onOpenTitleDescriptionPage,
		onOpenMediaSelectionPage = props.onOpenMediaSelectionPage,
		onOpenVersionTitleDescriptionPage = props.onOpenVersionTitleDescriptionPage,
		onOpenVersionHistory = props.onOpenVersionHistory,
		isNewGame = 0,
		layoutOrder = 2
	}
	local isNewGame

	if FFlagBuildCheckGamePermissions then
		isNewGame = props.target.isNewGameTarget
	end

	v3.isNewGame = isNewGame
	v2.Configuration = createElement4(PublishConfigurationContentContainer, v3)
	children.Content = createElement2(PublishSheetContent, { scrollingFrameRef = ref }, {
		Body = createElement3(View, { tag = "col gap-large size-full-0 auto-y" }, v2)
	})

	local createElement5 = React.createElement
	local actions = Sheet.Actions
	local createElement6 = React.createElement
	local target = {
		universeId = props.target.universeId,
		placeId = props.target.placeId,
		sessionId = props.target.sessionId,
		isNewGameTarget = 0
	}
	local isNewGameTarget

	if FFlagBuildCheckGamePermissions then
		isNewGameTarget = props.target.isNewGameTarget
	end

	target.isNewGameTarget = isNewGameTarget
	children.Actions = createElement5(actions, nil, {
		Footer = createElement6(PublishFooter, {
			target = target,
			testId = testId,
			showPreviewButton = props.showPreviewButton,
			onPreview = props.onClose
		})
	})
	return createElement(root, v, children)
end

return PublishBottomSheet
