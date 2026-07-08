local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local ParentParent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local Colors = require(ParentParent.Colors)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local InspectAndBuyContext = require(ParentParent.Components.InspectAndBuyContext)
local v12 = Roact.PureComponent:extend("PlayerNameLabel")
local verified = VerifiedBadges.emoji.verified

function v12.render(p1) -- line: 21
	-- upvalues: Players (copy), UserLib (copy), RobloxTranslator (copy), verified (copy), Roact (copy), InspectAndBuyContext (copy), Colors (copy), AppFonts (copy)
	local locale = p1.props.locale
	local view = p1.props.view
	local playerName = p1.props.playerName
	local num = tonumber(p1.props.playerId)
	local v19 = num and Players:GetPlayerByUserId(num)
	local v20 = not not v19 and UserLib.Utils.isPlayerVerified(v19)
	local u21 = if playerName ~= "" then if not v20 then RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Label.Avatar", locale, {
		PLAYER_NAME = playerName
	}) else RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Label.VerifiedAvatar", locale, {
		PLAYER_NAME = playerName,
		VERIFIED_BADGE = verified
	}) else ""

	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p2) -- line: 43
			-- upvalues: view (copy), Roact (copy), Colors (copy), u21 (ref), AppFonts (copy)
			local v25 = p2[view]
			local v26 = v25.AvatarHeadShotSize + v25.BorderPaddingSize * 2 + 10

			return Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextScaled = true,
				TextSize = 36,
				LayoutOrder = 2,
				Size = UDim2.new(1, -v26, 0, v25.TopSizeY),
				TextColor3 = Colors.White,
				Text = u21,
				Font = AppFonts.default:getBlack(),
				TextXAlignment = Enum.TextXAlignment.Left
			}, {
				TextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
					MaxTextSize = 36
				})
			})
		end
	})
end

return RoactRodux.UNSTABLE_connect2(function(p3, _) -- line: 66
	return {
		view = p3.view,
		playerName = p3.playerName,
		playerId = p3.playerId,
		locale = p3.locale
	}
end)(v12)
