local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local React = require(CorePackages.Packages.React)

local UIBlox = require(CorePackages.Packages.UIBlox)

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local robloxClientChannel = RunService:GetRobloxClientChannel()
local robloxVersion = RunService:GetRobloxVersion()
local coreScriptVersion = RunService:GetCoreScriptVersion()

local clientGitHash = RunService.ClientGitHash
local v5 = string.format("%s (%.6s)", robloxVersion, clientGitHash)

local function VersionSection(p2)
	local v6 = useLocalization({
		buildVersionText = {
			"CommonUI.Features.Label.VersionWithNumber",
			versionNumber = v5
		},
		clientChannelText = {
			"CommonUI.Features.Label.ChannelWithChannelName",
			channelName = robloxClientChannel
		},
		coreScriptVersionText = {
			"CommonUI.Features.Label.ClientCoreScriptVersion",
			clientCoreScriptVersion = coreScriptVersion
		}
	})

	local v7 = useDesignTokens(function(p3)
		return {
			bodyTextFont = p3.Typography.BodyLarge,
			bodyTextColor = p3.Color.Content.Default
		}
	end)

	return React.createElement(
		"Frame",
		{ AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1 },
		{
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			BuildVersionText = React.createElement(styledTextLabel, {
				layoutOrder = 1,
				text = v6.buildVersionText,
				fontStyle = v7.bodyTextFont,
				colorStyle = v7.bodyTextColor
			}),
			ClientCSVersionText = React.createElement(styledTextLabel, {
				layoutOrder = 2,
				text = v6.coreScriptVersionText,
				fontStyle = v7.bodyTextFont,
				colorStyle = v7.bodyTextColor
			}),
			ClientChannelText = React.createElement(styledTextLabel, {
				layoutOrder = 3,
				text = v6.clientChannelText,
				fontStyle = v7.bodyTextFont,
				colorStyle = v7.bodyTextColor
			})
		}
	)
end

return VersionSection
