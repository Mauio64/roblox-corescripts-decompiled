local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId
local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddTestIdsForArrow
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/VerifiedBadges")
local guildedLogoWhiteAsset = require("@luauforge/bundled/dBe").Constants.GuildedLogoWhiteAsset
local profileTypes = require("@luauforge/bundled/eef").ProfileTypes

local module2 = require("@luauforge/bundled/fWW")
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local navigateToBadgesSeeAll = require("@luauforge/deferred/fXm").navigateToBadgesSeeAll

local navigateToDevStoreSeeAll = require("@luauforge/bundled/fXn").navigateToDevStoreSeeAll

local gameDetailsSubpage = require("@luauforge/bundled/dpZ").Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents.GameDetailsSubpage

local module3 = require("@luauforge/bundled/edB")
local module4 = require("@luauforge/bundled/fXo")
local module5 = require("@luauforge/bundled/fue")
local module6 = require("@luauforge/bundled/fNO")

local module7 = require("@luauforge/deferred/fXp")

local module8 = require("@luauforge/bundled/ftp")

local openCloseOnlyInteractiveAlert = require("@luauforge/bundled/fXq").OpenCloseOnlyInteractiveAlert

local module9 = require("@luauforge/deferred/fXr")

local fFlagLuaAppAddUniverseIdToGameDetailsEvents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddUniverseIdToGameDetailsEvents

local defineFastFlag = game:DefineFastFlag("LuaAppRemoveDeadGameInfoRowTooltipBranch", false)

local fFlagLuaAppBadgesSeeAllEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppBadgesSeeAllEnabled

local fStringLuaAppBadgesSeeAllIxpLayer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FStringLuaAppBadgesSeeAllIxpLayer

local fFlagLuaAppBadgesSeeAllLogExposure = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppBadgesSeeAllLogExposure

local fFlagLuaAppDevStoreSeeAllSduiEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppDevStoreSeeAllSduiEnabled

local fFlagLuaAppDevStoreSeeAllSduiLogExposure = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppDevStoreSeeAllSduiLogExposure

local fStringLuaAppDevStoreSeeAllSduiIxpLayer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FStringLuaAppDevStoreSeeAllSduiIxpLayer

local module10 = require("@luauforge/deferred/fXs")

local fFlagEnableBlackbirdPageCloseCallback = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableBlackbirdPageCloseCallback

local iconsactionscycleRight = images["icons/actions/cycleRight"]

local extended = Roact.PureComponent:extend("GameInfoRow")

extended.defaultProps = { leftPadding = 0, rightPadding = 0 }

function extended:init()
	self.infoNameTextLabelRef = Roact.createRef()
	local binding, v5 = Roact.createBinding(0)
	self.maxRightContentWidth = binding
	self.setMaxRightContentWidth = v5

	self.state = { buttonPressed = false }

	function self.onAbsoluteSizeChange(p2)
		local x = p2.AbsoluteSize.X
		self.setMaxRightContentWidth((math.floor(x - (self.props.leftPadding + self.props.rightPadding))))
	end

	function self.onInputBegan(p2, p3)
		if
			p3.UserInputState == Enum.UserInputState.Begin
			and (p3.UserInputType == Enum.UserInputType.Touch or p3.UserInputType == Enum.UserInputType.MouseButton1)
			and not self.state.buttonPressed
		then
			self:setState({ buttonPressed = true })
		end
	end

	function self.onInputEnded()
		if self.state.buttonPressed then
			self:setState({ buttonPressed = false })
		end
	end

	function self.onActivated()
		local linkPage = self.props.linkPage
		local linkView = self.props.linkView
		local linkUrl = self.props.linkUrl

		if not (linkPage or linkView or linkUrl) then
			return
		end

		local eventIngest = self.props.eventIngest
		local universeId = self.props.universeId

		if linkUrl then
			self.props.openLeaveRobloxAlert(function()
				self.props.linking:openURL(linkUrl)
				self.props.closeAlert()

				local linkClickCallback = self.props.linkClickCallback

				if linkClickCallback then
					linkClickCallback()
				end
			end)
			return
		end

		local placeId = self.props.placeId
		local analyticsSubPage = self.props.analyticsSubPage

		gameDetailsSubpage(
			eventIngest,
			"GameInfoRow",
			placeId,
			analyticsSubPage,
			if fFlagLuaAppAddUniverseIdToGameDetailsEvents then universeId else nil
		)

		local text = self.infoNameTextLabelRef.current.Text

		if linkView == appPage.ExperienceGuidelinesExplained then
			self.props.openExperienceGuidelinesExplained(universeId)
		elseif linkView == appPage.PassesPage then
			if fFlagLuaAppDevStoreSeeAllSduiLogExposure then
				IXPService:LogFlagLinkedUserLayerExposure(fStringLuaAppDevStoreSeeAllSduiIxpLayer)
			end

			if fFlagLuaAppDevStoreSeeAllSduiEnabled then
				navigateToDevStoreSeeAll(self.props.navigation, universeId)
			else
				self.props.navigateDown({
					name = appPage.PassesPage,
					detail = universeId,
					extraProps = module10() and { viewWidth = self.props.viewWidth } or nil
				})
			end
		else
			if fFlagLuaAppBadgesSeeAllLogExposure and analyticsSubPage == "Badges" then
				IXPService:LogFlagLinkedUserLayerExposure(fStringLuaAppBadgesSeeAllIxpLayer)
			end

			if fFlagLuaAppBadgesSeeAllEnabled and linkView == appPage.BadgesSeeAll then
				navigateToBadgesSeeAll(self.props.navigation, universeId)
				return
			end

			if not defineFastFlag then
				if linkView == "UpdatedGenre" then
					local localization = self.props.localization

					self.props.openCloseOnlyInteractiveAlert(
						self.props.infoData,
						localization:Format("Feature.GameDetails.Label.GenreInProgress"),
						self.props.closeAlert
					)

					return
				elseif linkView == "GenreUnderConstruction" then
					local localization = self.props.localization
					local v9 = nil

					if module9 == "UnderConstruction" then
						v9 = localization:Format("Feature.GameDetails.Label.GenreUnderConstruction")
					elseif module9 == "InProgress" then
						v9 = localization:Format("Feature.GameDetails.Label.GenreInProgress")
					end

					if v9 then
						self.props.openCloseOnlyInteractiveAlert(
							localization:Format("Feature.GameDetails.Label.Unavailable"),
							v9,
							self.props.closeAlert
						)
					end

					return
				end
			end

			if
				module2.FFlagIsSetupEnabled
				and (analyticsSubPage == "Developer" or analyticsSubPage == "Group")
			then
				module2.logExposure()
			end

			if
				module2.FFlagIsSetupEnabled
				and linkView == "CommunityProfilePlatform"
				and self.props.linkViewData ~= nil
			then
				local linkViewData = self.props.linkViewData
				self.props.openCommunityProfilePage(
					linkViewData,
					`ExperienceDetailsPage:{analyticsSubPage}`
				)
			elseif linkView == "UserProfilePlatform" and self.props.linkViewData ~= nil then
				local linkViewData = self.props.linkViewData
				self.props.openUserProfilePage(linkViewData, `ExperienceDetailsPage:{analyticsSubPage}`)
			else
				local navigateDown2 = self.props.navigateDown
				local v9 = {
					name = appPage.GenericWebPage,
					detail = linkPage,
					extraProps = 0
				}

				local v10 = {
					title = text,
					transitionAnimation = module5.SlideInFromRight,
					onClose = 0
				}
				local v11 = if fFlagEnableBlackbirdPageCloseCallback then self.props.onClose else nil
				v10.onClose = v11
				v9.extraProps = v10
				navigateDown2(v9)
			end
		end
	end
end

function extended.render(props)
	local cells = props.props.appTheme.GameDetails.GameInfoList.Cells
	local size = props.props.Size
	local position = props.props.Position
	local layoutOrder = props.props.LayoutOrder
	local v5 = props.state.buttonPressed

	local infoName = props.props.infoName
	local infoData = props.props.infoData or ""
	local v6 = props.props.infoIcon == guildedLogoWhiteAsset

	local v7 = props.props.linkPage ~= nil or (props.props.linkView or props.props.linkUrl)
	local leftPadding = props.props.leftPadding
	local rightPadding = props.props.rightPadding
	local topPadding = props.props.topPadding
	local bottomPadding = props.props.bottomPadding

	if not v7 then
		v5 = false
	end

	local function getInfoDataTextLabel(p2, props2)
		local createElement = Roact.createElement
		local v9 = {}
		v9.Size = UDim2.new(0, 0, 0, 0)
		v9.TextTruncate = Enum.TextTruncate.SplitWord
		v9.BackgroundTransparency = 1
		v9.BorderSizePixel = 0
		local v10 = if not foundationFontFaceMigration then props2.Font.Header2.Font else nil
		v9.Font = v10

		local v11 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.TitleLarge.Font) else nil
		v9.FontFace = v11

		v9.TextSize = props2.Font.BaseSize * props2.Font.Header2.RelativeSize
		v9.TextColor3 = props2.Theme.TextEmphasis.Color
		v9.TextTransparency = props2.Theme.TextEmphasis.Transparency
		v9.Text = infoData
		v9.TextXAlignment = Enum.TextXAlignment.Left
		v9.TextYAlignment = Enum.TextYAlignment.Center
		v9.TextWrapped = false
		v9.AutomaticSize = Enum.AutomaticSize.XY
		v9.LayoutOrder = 1
		local tag = React.Tag
		local v12 = if props.props.testId then `data-testid={props.props.testId}` else nil
		v9[tag] = v12
		return createElement("TextLabel", v9)
	end

	local style = props.props.style
	local v8

	if props.props.testId then
		v8 = string.gsub(props.props.testId, "^%-%-", "")
	else
		v8 = props.props.infoName
	end

	local createElement = Roact.createElement
	local v10 = {
		Size = size,
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = position,
		AutoButtonColor = false,
		LayoutOrder = layoutOrder,
		BorderSizePixel = 0,
		BackgroundTransparency = v5 and cells.Background.Transparency.Pressed or cells.Background.Transparency.Default,
		BackgroundColor3 = cells.Background.Color,
		[Roact.Event.InputBegan] = props.onInputBegan,
		[Roact.Event.InputEnded] = props.onInputEnded,
		[Roact.Event.Activated] = props.onActivated,
		[Roact.Change.AbsoluteSize] = props.onAbsoluteSizeChange
	}
	local tag = React.Tag
	local v11 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-edp-game-info-row", v8) else nil
	v10[tag] = v11

	local children = {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Wraps = true,
			Padding = UDim.new(0, style.Tokens.Size.Size_200)
		}),
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, leftPadding),
			PaddingRight = UDim.new(0, rightPadding),
			PaddingTop = UDim.new(0, topPadding),
			PaddingBottom = UDim.new(0, bottomPadding)
		}),
		RightContent = 0,
		InfoNameTextLabel = 0
	}

	local createElement2 = Roact.createElement
	local v13 = {
		Size = UDim2.new(0, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = 2,
		BackgroundTransparency = 1
	}

	local v14 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, 11),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			HorizontalFlex = Enum.UIFlexAlignment.Fill
		}),
		UISizeConstraint = Roact.createElement("UISizeConstraint", {
			MaxSize = props.maxRightContentWidth:map(function(p2)
				return Vector2.new(p2, 1e999)
			end)
		}),
		InfoIcon = v6 and Roact.createElement(imageSetLabel, {
			Size = UDim2.new(0, 20, 0, 20),
			Image = props.props.infoIcon,
			ImageColor3 = style.Theme.IconEmphasis.Color,
			ImageTransparency = style.Theme.IconEmphasis.Transparency,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}),
		InfoDataTextLabelVerifiedBadge = props.props.useVerifiedBadgeEmojiWrapper and Roact.createElement(VerifiedBadges.EmojiWrapper, {
			emoji = not props.props.useVerifiedBadgeEmojiWrapper and "" or VerifiedBadges.emoji.verified,
			size = UDim2.new(0, 0, 0, 0),
			anchorPoint = Vector2.new(1, 0),
			automaticSize = Enum.AutomaticSize.XY,
			horizontalAlignment = Enum.HorizontalAlignment.Left,
			verticalAlignment = Enum.VerticalAlignment.Center,
			layoutOrder = 1
		}, {
			InfoDataTextLabel = getInfoDataTextLabel(true, style)
		}),
		InfoDataTextLabel = 0,
		LinkArrow = 0
	}

	local v15 = if not props.props.useVerifiedBadgeEmojiWrapper and infoData ~= "" then getInfoDataTextLabel(false, style) else nil
	v14.InfoDataTextLabel = v15

	if v7 then
		local createElement3 = Roact.createElement
		local v17 = {
			["Size"] = UDim2.new(0, 14, 0, 14),
			Image = iconsactionscycleRight,
			ImageColor3 = style.Theme.IconEmphasis.Color,
			ImageTransparency = style.Theme.IconEmphasis.Transparency,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 3
		}

		local tag2 = React.Tag
		local v18 = if props.props.testId then `data-testid={props.props.testId}` else nil
		v17[tag2] = v18
		v7 = createElement3(imageSetLabel, v17)
	end

	v14.LinkArrow = v7
	children.RightContent = createElement2("Frame", v13, v14)

	children.InfoNameTextLabel = Roact.createElement(
		props.props.disableInfoNameLocalization and "TextLabel" or module4,
		{
			Size = UDim2.new(infoData == "" and 1 or 0, infoData == "" and -25 or 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Font = style.Font.Body.Font,
			TextSize = style.Font.BaseSize * style.Font.Body.RelativeSize,
			TextColor3 = style.Theme.TextDefault.Color,
			TextTransparency = style.Theme.TextDefault.Transparency,
			Text = infoName,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextWrapped = true,
			[Roact.Ref] = props.infoNameTextLabelRef,
			LayoutOrder = 1
		}
	)
	return createElement("ImageButton", v10, children)
end

local v5 = module6(extended)

local v6 = RoactRodux.connect(nil, function(callback)
	return {
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			end

			return callback(navigateDown(p2))
		end,
		openExperienceGuidelinesExplained = function(p2)
			callback(module7(p2, false))
		end,
		openLeaveRobloxAlert = function(p2)
			callback(module8(p2))
		end,
		openCloseOnlyInteractiveAlert = not defineFastFlag and function(p2, p3, p4)
			callback(openCloseOnlyInteractiveAlert(p2, p3, p4, nil, false))
		end or nil,
		closeAlert = not defineFastFlag and function()
			callback(closeCentralOverlay())
		end or nil,
		openCommunityProfilePage = module2.FFlagIsSetupEnabled and function(p2, p3)
			local v7 = {
				name = appPage.ProfilePlatform,
				detail = p2,
				extraProps = { profileType = profileTypes.Community, source = p3 }
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v7))
			else
				callback(navigateDown(v7))
			end
		end or nil,
		openUserProfilePage = function(p2, p3)
			local v7 = {
				name = appPage.ProfilePlatform,
				detail = p2,
				extraProps = { profileType = profileTypes.User, source = p3 }
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v7))
			else
				callback(navigateDown(v7))
			end
		end
	}
end)(function(p2)
	local v7 = useStyle()
	local v8

	if fFlagLuaAppBadgesSeeAllEnabled or fFlagLuaAppDevStoreSeeAllSduiEnabled then
		v8 = useNavigation()
	end

	local joined = Cryo.Dictionary.join(p2, { style = v7, navigation = v8 })

	return Roact.createElement(v5, joined)
end)

return roactServices.connect({
	eventIngest = appEventIngestService,
	linking = appLinking,
	localization = module3
})(v6)
