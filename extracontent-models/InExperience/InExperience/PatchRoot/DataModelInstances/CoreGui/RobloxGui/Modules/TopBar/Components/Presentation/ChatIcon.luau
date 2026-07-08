local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local VRService = game:GetService("VRService")

game:GetService("AppStorageService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local _ = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local withStyle = UIBlox.Core.Style.withStyle
local Badge = UIBlox.App.Indicator.Badge
local BadgeStates = UIBlox.App.Indicator.Enum.BadgeStates
local Images = UIBlox.App.ImageSet.Images
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local ChatSelector = require(RobloxGui.Modules.ChatSelector)
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local IconButton = require(script.Parent.IconButton)
local ParentParent = script.Parent.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local v19 = require(ParentParent.Flags.GetFFlagEnableTopBarAnalytics)()
local SetKeepOutArea = require(ParentParent.Actions.SetKeepOutArea)
local RemoveKeepOutArea = require(ParentParent.Actions.RemoveKeepOutArea)
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas
local Constants = require(ParentParent.Constants)
local GetFFlagEnableAppChatInExperience = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAppChatInExperience

require(script.Parent.ChatIconFtuxTooltip)

local getExperienceChatVisualConfig = require(CorePackages.Workspace.Packages.ExpChat).getExperienceChatVisualConfig

game:DefineFastInt("InExperienceChatTooltipShowDelayMs", 1000)
game:DefineFastInt("InExperienceChatTooltipDismissDelayMs", 7000)

local v27 = game:DefineFastFlag("UnibarHoldoutChatIconUseNewIconSize", false)
local GameSettings = UserSettings().GameSettings

local function shouldShowEmptyBadge() -- line: 43
	return game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService
end

local v30 = Roact.PureComponent:extend("ChatIcon")

v30.validateProps = t.strictInterface({
	layoutOrder = t.integer,
	chatVisible = t.boolean,
	unreadMessages = t.integer,
	topBarEnabled = t.boolean,
	chatEnabled = t.boolean,
	setKeepOutArea = if not FFlagTopBarSignalizeKeepOutAreas then t.callback else nil,
	removeKeepOutArea = if not FFlagTopBarSignalizeKeepOutAreas then t.callback else nil
})

function v30.init(p1) -- line: 69
	-- upvalues: Roact (copy), ChatSelector (copy), GameSettings (copy), v19 (copy), Analytics (copy), FFlagTopBarSignalizeKeepOutAreas (copy), CoreGuiCommon (copy)
	p1.buttonRef = Roact.createRef()

	function p1.chatIconActivated() -- line: 72
		-- upvalues: ChatSelector (copy), GameSettings (copy), v19 (copy), Analytics (copy)
		ChatSelector:ToggleVisibility()
		GameSettings.ChatVisible = ChatSelector:GetVisibility()

		if v19 then
			Analytics.default:onChatButtonActivated(GameSettings.ChatVisible)
		end
	end

	if FFlagTopBarSignalizeKeepOutAreas then
		p1.keepOutAreasStore = CoreGuiCommon.Stores.GetKeepOutAreasStore(false)
	end
end
function v30.render(p2) -- line: 85
	-- upvalues: withStyle (copy), TenFootInterface (copy), VRService (copy), getExperienceChatVisualConfig (copy), Images (copy), FFlagTopBarSignalizeKeepOutAreas (copy), Constants (copy), Roact (copy), IconButton (copy), GetFFlagEnableAppChatInExperience (copy), v27 (copy), Badge (copy), BadgeStates (copy)
	return withStyle(function(_) -- line: 86
		-- upvalues: p2 (copy), TenFootInterface (copy), VRService (copy), getExperienceChatVisualConfig (copy), Images (copy), FFlagTopBarSignalizeKeepOutAreas (copy), Constants (copy), Roact (copy), IconButton (copy), GetFFlagEnableAppChatInExperience (copy), v27 (copy), Badge (copy), BadgeStates (copy)
		local v38 = p2.props.topBarEnabled and (p2.props.chatEnabled and (not TenFootInterface:IsEnabled() and not VRService.VREnabled))
		local v39 = getExperienceChatVisualConfig()
		local iconSize = v39.iconSize
		local v41 = Images[v39.icon.on]

		if not p2.props.chatVisible then
			v41 = Images[v39.icon.off]
		end

		local function v42(p4) -- line: 102
			-- upvalues: v38 (copy), FFlagTopBarSignalizeKeepOutAreas (copy), p2 (copy), Constants (copy)
			if v38 and p4 then
				if FFlagTopBarSignalizeKeepOutAreas then
					p2.keepOutAreasStore.setKeepOutArea(Constants.ChatIconKeepOutAreaId, p4.AbsolutePosition, p4.AbsoluteSize)

					return
				end

				p2.props.setKeepOutArea(Constants.ChatIconKeepOutAreaId, p4.AbsolutePosition, p4.AbsoluteSize)

				return
			end

			if FFlagTopBarSignalizeKeepOutAreas then
				p2.keepOutAreasStore.removeKeepOutArea(Constants.ChatIconKeepOutAreaId)

				return
			end

			p2.props.removeKeepOutArea(Constants.ChatIconKeepOutAreaId)
		end

		if p2.buttonRef.current then
			v42(p2.buttonRef.current)
		end

		local v43 = Roact.createElement(IconButton, {
			icon = v41,
			iconSize = not GetFFlagEnableAppChatInExperience() and not v27 and 20 or iconSize,
			onActivated = p2.chatIconActivated,
			[Roact.Change.AbsoluteSize] = v42,
			[Roact.Change.AbsolutePosition] = v42,
			[Roact.Ref] = function(p5) -- line: 118
				-- upvalues: p2 (copy), v42 (copy)
				if p5 then
					p2.buttonRef.current = p5
					v42(p2.buttonRef.current)
				end
			end
		})

		return Roact.createElement("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			Selectable = false,
			Visible = v38,
			Size = UDim2.new(0, 44, 1, 0),
			LayoutOrder = p2.props.layoutOrder
		}, {
			Background = v43,
			BadgeContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1)
			}, {
				Badge = p2.props.unreadMessages > 0 and Roact.createElement(Badge, {
					hasShadow = false,
					position = UDim2.fromOffset(18, game:GetService("TextChatService").ChatVersion ~= Enum.ChatVersion.TextChatService and 2 or 6),
					anchorPoint = Vector2.new(0, 0),
					value = game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService and BadgeStates.isEmpty or p2.props.unreadMessages
				})
			})
		})
	end)
end

local function mapStateToProps(p6) -- line: 167
	return {
		chatVisible = p6.chat.visible,
		unreadMessages = p6.chat.unreadMessages,
		topBarEnabled = p6.displayOptions.topbarEnabled,
		chatEnabled = p6.coreGuiEnabled[Enum.CoreGuiType.Chat]
	}
end
local function mapDispatchToProps(p7) -- line: 177
	-- upvalues: FFlagTopBarSignalizeKeepOutAreas (copy), SetKeepOutArea (copy), RemoveKeepOutArea (copy)
	if FFlagTopBarSignalizeKeepOutAreas then
		return {}
	end

	return {
		setKeepOutArea = function(p8, p9, p10) -- line: 182
			-- upvalues: p7 (copy), SetKeepOutArea (copy)
			return p7(SetKeepOutArea(p8, p9, p10))
		end,
		removeKeepOutArea = function(p11) -- line: 185
			-- upvalues: p7 (copy), RemoveKeepOutArea (copy)
			return p7(RemoveKeepOutArea(p11))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, (if not FFlagTopBarSignalizeKeepOutAreas then mapDispatchToProps else nil))(v30)
