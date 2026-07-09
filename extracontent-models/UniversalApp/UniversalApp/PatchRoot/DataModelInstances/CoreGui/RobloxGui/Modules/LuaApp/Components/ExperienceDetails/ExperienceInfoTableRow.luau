local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local withStyle = UIBlox.Core.Style.withStyle
local Cell = UIBlox.App.Table.Cell
local CellHeadDetail = UIBlox.App.Table.CellHeadDetail
local CellTailDescription = UIBlox.App.Table.CellTailDescription
local t = require(CorePackages.Packages.t)
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local EnableCommunityProfilePageIXP = require(CorePackages.Workspace.Packages.ProfilePlatform.EnableCommunityProfilePageIXP)
local GameDetailsSubpage = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents.GameDetailsSubpage
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local TransitionAnimation = require(Modules.LuaApp.Enum.TransitionAnimation)
local FFlagExperienceDetailsTextUseTokens = require(script.Parent.Flags.FFlagExperienceDetailsTextUseTokens)
local FFlagLuaAppAddUniverseIdToGameDetailsEvents = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppAddUniverseIdToGameDetailsEvents
local FStringLuaAppBadgesSeeAllIxpLayer = require(CorePackages.Workspace.Packages.SharedFlags).FStringLuaAppBadgesSeeAllIxpLayer
local FFlagLuaAppBadgesSeeAllLogExposure = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppBadgesSeeAllLogExposure
local FStringLuaAppDevStoreSeeAllSduiIxpLayer = require(CorePackages.Workspace.Packages.SharedFlags).FStringLuaAppDevStoreSeeAllSduiIxpLayer
local FFlagLuaAppDevStoreSeeAllSduiLogExposure = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppDevStoreSeeAllSduiLogExposure
local FFlagEnableBlackbirdPageCloseCallback = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableBlackbirdPageCloseCallback

local function applyTokenScaling(n1: number, p1) -- line: 40
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	return n1 * (p1.Stroke and p1.Stroke.Standard or (p1.Global and (if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Stroke_100 else p1.Stroke.Standard) or 1))
end

local v24 = Roact.PureComponent:extend("ExperienceInfoTableRow")

v24.validateProps = t.strictInterface({
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
	universeId = if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else t.optional(t.string),
	testId = t.optional(t.string)
})

function v24.init(p2) -- line: 77
	-- upvalues: AppPage (copy), TransitionAnimation (copy), FFlagEnableBlackbirdPageCloseCallback (copy), GameDetailsSubpage (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy), EnableCommunityProfilePageIXP (copy), FFlagLuaAppBadgesSeeAllLogExposure (copy), IXPService (copy), FStringLuaAppBadgesSeeAllIxpLayer (copy), FFlagLuaAppDevStoreSeeAllSduiLogExposure (copy), FStringLuaAppDevStoreSeeAllSduiIxpLayer (copy)
	function p2.onActivated() -- line: 78
		-- upvalues: p2 (copy), AppPage (copy), TransitionAnimation (copy), FFlagEnableBlackbirdPageCloseCallback (copy), GameDetailsSubpage (copy), FFlagLuaAppAddUniverseIdToGameDetailsEvents (copy), EnableCommunityProfilePageIXP (copy), FFlagLuaAppBadgesSeeAllLogExposure (copy), IXPService (copy), FStringLuaAppBadgesSeeAllIxpLayer (copy), FFlagLuaAppDevStoreSeeAllSduiLogExposure (copy), FStringLuaAppDevStoreSeeAllSduiIxpLayer (copy)
		local externalLinkProps = p2.props.externalLinkProps

		if externalLinkProps then
			externalLinkProps.openLeaveRobloxAlert(function() -- line: 81
				-- upvalues: externalLinkProps (copy)
				externalLinkProps.linking:openURL(externalLinkProps.linkUrl)
				externalLinkProps.closeAlert()

				local clickCallback = externalLinkProps.clickCallback

				if clickCallback then
					clickCallback()
				end
			end)

			return
		end

		local linkProps = p2.props.linkProps

		if not linkProps then
			return
		end

		local infoName = p2.props.infoName
		local linkPage = linkProps.linkPage
		local rootPlaceId = linkProps.rootPlaceId
		local analyticsSubPage = linkProps.analyticsSubPage
		local eventIngest = linkProps.eventIngest
		local navigate = linkProps.navigate
		local v45 = if not linkProps.navigateProps then {
			name = AppPage.GenericWebPage,
			detail = linkPage,
			extraProps = {
				title = infoName,
				transitionAnimation = TransitionAnimation.SlideInFromRight,
				onClose = if not FFlagEnableBlackbirdPageCloseCallback then nil else linkProps.onClose
			}
		} else linkProps.navigateProps

		GameDetailsSubpage(eventIngest, "GameInfoRow", rootPlaceId, analyticsSubPage, if not FFlagLuaAppAddUniverseIdToGameDetailsEvents then nil else p2.props.universeId)

		if EnableCommunityProfilePageIXP.FFlagIsSetupEnabled and (analyticsSubPage == "Developer" or analyticsSubPage == "Group") then
			EnableCommunityProfilePageIXP.logExposure()
		end

		if FFlagLuaAppBadgesSeeAllLogExposure and analyticsSubPage == "Badges" then
			IXPService:LogFlagLinkedUserLayerExposure(FStringLuaAppBadgesSeeAllIxpLayer)
		end

		if FFlagLuaAppDevStoreSeeAllSduiLogExposure and analyticsSubPage == "PassesAndGear" then
			IXPService:LogFlagLinkedUserLayerExposure(FStringLuaAppDevStoreSeeAllSduiIxpLayer)
		end

		navigate(v45)
	end
end
function v24.render(p3) -- line: 139
	-- upvalues: withStyle (copy), Roact (copy), Cell (copy), FFlagRenameDeprecatedUIBloxTokens (copy), CellHeadDetail (copy), FFlagExperienceDetailsTextUseTokens (copy), CellTailDescription (copy)
	local infoName = p3.props.infoName
	local infoData = p3.props.infoData
	local infoIcon = p3.props.infoIcon
	local testId = p3.props.testId
	local linkProps = p3.props.linkProps
	local externalLinkProps = p3.props.externalLinkProps
	local v35 = linkProps and true or not not externalLinkProps
	local renderTextOverride = p3.props.renderTextOverride

	return withStyle(function(p4) -- line: 150
		-- upvalues: Roact (copy), Cell (copy), FFlagRenameDeprecatedUIBloxTokens (copy), v35 (copy), p3 (copy), CellHeadDetail (copy), infoName (copy), FFlagExperienceDetailsTextUseTokens (copy), CellTailDescription (copy), infoData (copy), renderTextOverride (copy), infoIcon (copy), testId (copy)
		local createElement = Roact.createElement
		local v48 = Cell
		local t1 = {
			selectable = true
		}
		local new = UDim2.new
		local Tokens = p4.Tokens

		t1.size = new(1, 0, 0, 56 * (Tokens.Stroke and Tokens.Stroke.Standard or (Tokens.Global and (if not FFlagRenameDeprecatedUIBloxTokens then Tokens.Global.Stroke_100 else Tokens.Stroke.Standard) or 1)))
		t1.userInteractionEnabled = v35
		t1.onActivated = v35 and p3.onActivated or nil
		t1.horizontalPadding = p3.props.horizontalPadding
		t1.head = Roact.createElement(CellHeadDetail, {
			labelText = infoName,
			labelTextColor = p4.Theme.TextDefault,
			labelTextFont = if not FFlagExperienceDetailsTextUseTokens then p4.Font.Body else if not FFlagRenameDeprecatedUIBloxTokens then p4.Tokens.Semantic.Typography.Body else p4.Tokens.Typography.BodyLarge
		})
		t1.tail = Roact.createElement(CellTailDescription, {
			text = infoData,
			textColor = p4.Theme.TextEmphasis,
			textFont = if not FFlagExperienceDetailsTextUseTokens then p4.Font.Body else if not FFlagRenameDeprecatedUIBloxTokens then p4.Tokens.Semantic.Typography.Subheader else p4.Tokens.Typography.TitleLarge,
			renderTextOverride = renderTextOverride,
			showArrow = v35,
			infoIcon = infoIcon,
			testId = testId
		})

		return createElement(v48, t1)
	end)
end

return v24
