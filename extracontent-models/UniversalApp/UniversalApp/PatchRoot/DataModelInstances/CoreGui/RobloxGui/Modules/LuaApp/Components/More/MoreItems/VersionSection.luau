local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local RobloxClientChannel = RunService:GetRobloxClientChannel()
local RobloxVersion = RunService:GetRobloxVersion()
local CoreScriptVersion = RunService:GetCoreScriptVersion()
local ClientGitHash = RunService.ClientGitHash
local u12 = string.format("%s (%.6s)", RobloxVersion, ClientGitHash)

local function VersionSection(_: {[any]: any}) -- line: 18
	-- upvalues: useLocalization (copy), u12 (ref), RobloxClientChannel (copy), CoreScriptVersion (copy), useDesignTokens (copy), React (copy), StyledTextLabel (copy)
	local v15 = useLocalization({
		buildVersionText = {
			"CommonUI.Features.Label.VersionWithNumber",
			versionNumber = u12
		},
		clientChannelText = {
			"CommonUI.Features.Label.ChannelWithChannelName",
			channelName = RobloxClientChannel
		},
		coreScriptVersionText = {
			"CommonUI.Features.Label.ClientCoreScriptVersion",
			clientCoreScriptVersion = CoreScriptVersion
		}
	})
	local v16 = useDesignTokens(function(p1) -- line: 28
		return {
			bodyTextFont = p1.Typography.BodyLarge,
			bodyTextColor = p1.Color.Content.Default
		}
	end)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		BuildVersionText = React.createElement(StyledTextLabel, {
			layoutOrder = 1,
			text = v15.buildVersionText,
			fontStyle = v16.bodyTextFont,
			colorStyle = v16.bodyTextColor
		}),
		ClientCSVersionText = React.createElement(StyledTextLabel, {
			layoutOrder = 2,
			text = v15.coreScriptVersionText,
			fontStyle = v16.bodyTextFont,
			colorStyle = v16.bodyTextColor
		}),
		ClientChannelText = React.createElement(StyledTextLabel, {
			layoutOrder = 3,
			text = v15.clientChannelText,
			fontStyle = v16.bodyTextFont,
			colorStyle = v16.bodyTextColor
		})
	})
end

return VersionSection
