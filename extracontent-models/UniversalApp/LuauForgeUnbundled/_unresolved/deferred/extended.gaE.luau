local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local withStyle = UIBlox.Core.Style.withStyle
local cell = UIBlox.App.Table.Cell
local cellHeadDetail = UIBlox.App.Table.CellHeadDetail
local cellTailDescription = UIBlox.App.Table.CellTailDescription
local t = require(CorePackages.Packages.t)
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

local module = require("@luauforge/bundled/fWW")

local gameDetailsSubpage = require("@luauforge/bundled/dpZ").Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents.GameDetailsSubpage

local module2 = require("@luauforge/bundled/fue")

local module3 = require("@luauforge/deferred/fZa")

local fFlagLuaAppAddUniverseIdToGameDetailsEvents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddUniverseIdToGameDetailsEvents

local fStringLuaAppBadgesSeeAllIxpLayer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FStringLuaAppBadgesSeeAllIxpLayer

local fFlagLuaAppBadgesSeeAllLogExposure = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppBadgesSeeAllLogExposure

local fStringLuaAppDevStoreSeeAllSduiIxpLayer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FStringLuaAppDevStoreSeeAllSduiIxpLayer

local fFlagLuaAppDevStoreSeeAllSduiLogExposure = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppDevStoreSeeAllSduiLogExposure

local fFlagEnableBlackbirdPageCloseCallback = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableBlackbirdPageCloseCallback

local function applyTokenScaling(p2, p3)
	return p2 * (p3.Stroke and p3.Stroke.Standard or 1)
end

local extended = Roact.PureComponent:extend("ExperienceInfoTableRow")

local strictInterface = t.strictInterface
local v5 = {
	horizontalPadding = t.optional(t.number),
	infoName = t.string,
	infoData = t.string,
	infoIcon = t.optional(t.string),
	renderTextOverride = t.optional(t.callback),
	linkProps = t.optional(t.strictInterface({
		linkPage = t.optional(t.string),
		analyticsSubPage = t.string,
		rootPlaceId = t.string,
		eventIngest = t.table,
		navigate = t.callback,
		navigateProps = t.optional(t.any),
		onClose = t.optional(t.callback)
	})),
	externalLinkProps = t.optional(t.strictInterface({
		linkUrl = t.string,
		openLeaveRobloxAlert = t.callback,
		closeAlert = t.callback,
		linking = t.table,
		clickCallback = t.optional(t.callback)
	})),
	universeId = 0,
	testId = 0
}

local v6 = if fFlagLuaAppAddUniverseIdToGameDetailsEvents then t.optional(t.string) else nil
v5.universeId = v6
v5.testId = t.optional(t.string)
extended.validateProps = strictInterface(v5)

function extended:init()
	function self.onActivated()
		local externalLinkProps = self.props.externalLinkProps

		if externalLinkProps then
			externalLinkProps.openLeaveRobloxAlert(function()
				externalLinkProps.linking:openURL(externalLinkProps.linkUrl)
				externalLinkProps.closeAlert()
				local clickCallback = externalLinkProps.clickCallback

				if clickCallback then
					clickCallback()
				end
			end)
			return
		end

		local linkProps = self.props.linkProps

		if not linkProps then
			return
		end

		local infoName = self.props.infoName
		local linkPage = linkProps.linkPage
		local rootPlaceId = linkProps.rootPlaceId
		local analyticsSubPage = linkProps.analyticsSubPage
		local eventIngest = linkProps.eventIngest
		local navigate = linkProps.navigate
		local v7

		if linkProps.navigateProps then
			v7 = linkProps.navigateProps
		else
			v7 = { name = appPage.GenericWebPage, detail = linkPage, extraProps = 0 }

			local v8 = {
				title = infoName,
				transitionAnimation = module2.SlideInFromRight,
				onClose = 0
			}
			local v9 = if fFlagEnableBlackbirdPageCloseCallback then linkProps.onClose else nil
			v8.onClose = v9
			v7.extraProps = v8
		end

		local v10 = if fFlagLuaAppAddUniverseIdToGameDetailsEvents then self.props.universeId else nil
		gameDetailsSubpage(eventIngest, "GameInfoRow", rootPlaceId, analyticsSubPage, v10)

		if
			module.FFlagIsSetupEnabled
			and (analyticsSubPage == "Developer" or analyticsSubPage == "Group")
		then
			module.logExposure()
		end

		if fFlagLuaAppBadgesSeeAllLogExposure and analyticsSubPage == "Badges" then
			IXPService:LogFlagLinkedUserLayerExposure(fStringLuaAppBadgesSeeAllIxpLayer)
		end

		if fFlagLuaAppDevStoreSeeAllSduiLogExposure and analyticsSubPage == "PassesAndGear" then
			IXPService:LogFlagLinkedUserLayerExposure(fStringLuaAppDevStoreSeeAllSduiIxpLayer)
		end

		navigate(v7)
	end
end

function extended.render(p2)
	local infoName = p2.props.infoName
	local infoData = p2.props.infoData
	local infoIcon = p2.props.infoIcon
	local testId = p2.props.testId

	local linkProps = p2.props.linkProps
	local externalLinkProps = p2.props.externalLinkProps
	local v7 = (linkProps or externalLinkProps) and true or false
	local renderTextOverride = p2.props.renderTextOverride

	return withStyle(function(props)
		local createElement = Roact.createElement
		local newUDim2 = UDim2.new
		local tokens = props.Tokens
		local children = {
			size = newUDim2(1, 0, 0, 56 * (tokens.Stroke and tokens.Stroke.Standard or 1)),
			selectable = true,
			userInteractionEnabled = v7,
			onActivated = v7 and p2.onActivated or nil,
			horizontalPadding = p2.props.horizontalPadding,
			head = 0,
			tail = 0
		}
		local createElement2 = Roact.createElement
		local v10 = {
			labelText = infoName,
			labelTextColor = props.Theme.TextDefault,
			labelTextFont = 0
		}

		local v11 = if module3 then props.Tokens.Typography.BodyLarge else props.Font.Body
		v10.labelTextFont = v11
		children.head = createElement2(cellHeadDetail, v10)

		local createElement3 = Roact.createElement
		local v13 = {
			text = infoData,
			textColor = props.Theme.TextEmphasis,
			textFont = 0,
			renderTextOverride = 0,
			showArrow = 0,
			infoIcon = 0,
			testId = 0
		}

		local v14 = if module3 then props.Tokens.Typography.TitleLarge else props.Font.Body
		v13.textFont = v14

		v13.renderTextOverride = renderTextOverride
		v13.showArrow = v7
		v13.infoIcon = infoIcon
		v13.testId = testId
		children.tail = createElement3(cellTailDescription, v13)
		return createElement(cell, children)
	end)
end

return extended
