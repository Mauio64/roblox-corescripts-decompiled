local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local parent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local Colors = require(parent.Colors)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)

local InspectAndBuyContext = require(parent.Components.InspectAndBuyContext)

local extended = Roact.PureComponent:extend("PlayerNameLabel")

local verified = VerifiedBadges.emoji.verified

function extended.render(p)
	local locale = p.props.locale
	local view = p.props.view
	local playerName = p.props.playerName
	local playerId = tonumber(p.props.playerId)
	local playerByUserId = playerId and Players:GetPlayerByUserId(playerId)
	local v

	if playerByUserId then
		v = UserLib.Utils.isPlayerVerified(playerByUserId)
	else
		v = false
	end

	local text

	if playerName == "" then
		text = ""
	elseif v then
		text = RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Label.VerifiedAvatar", locale, {
			PLAYER_NAME = playerName,
			VERIFIED_BADGE = verified
		})
	else
		text = RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Label.Avatar", locale, {
			PLAYER_NAME = playerName
		})
	end

	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p2)
			local v2 = p2[view]
			local v3 = v2.AvatarHeadShotSize + v2.BorderPaddingSize * 2 + 10

			return Roact.createElement("TextLabel", {
				Size = UDim2.new(1, -v3, 0, v2.TopSizeY),
				BackgroundTransparency = 1,
				TextColor3 = Colors.White,
				TextScaled = true,
				Text = text,
				TextSize = 36,
				Font = AppFonts.default:getBlack(),
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 2
			}, {
				TextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
					MaxTextSize = 36
				})
			})
		end
	})
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	return {
		view = data.view,
		playerName = data.playerName,
		playerId = data.playerId,
		locale = data.locale
	}
end)(extended)
