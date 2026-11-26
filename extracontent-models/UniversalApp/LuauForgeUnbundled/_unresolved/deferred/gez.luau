local CorePackages = game:GetService("CorePackages")
local InsertService = game:GetService("InsertService")
local RunService = game:GetService("RunService")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local module = require("@luauforge/bundled/egZ")
local Foundation = require(CorePackages.Packages.Foundation)
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local module2 = require("@luauforge/bundled/fvR")
local module3 = require("@luauforge/bundled/fGj")
local module4 = require("@luauforge/deferred/fHR")

local robloxClientChannel = RunService:GetRobloxClientChannel()
local robloxVersion = RunService:GetRobloxVersion()
local coreScriptVersion = RunService:GetCoreScriptVersion()

local clientGitHash = RunService.ClientGitHash
local v5 = string.format("%s (%.6s)", robloxVersion, clientGitHash)

local function VersionLabel(p2)
	local v6 = useTokens()

	if p2.headerText and p2.contentText then
		return React.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			},
			{
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					Wraps = true
				}),
				HeaderText = React.createElement(text, {
					Size = UDim2.new(0, 0, 0, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = p2.headerText,
					fontStyle = v6.Typography.BodyMedium,
					textStyle = v6.Color.Content.Emphasis,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.XY,
					LayoutOrder = 1
				}),
				ContentText = React.createElement(text, {
					Size = UDim2.new(0, 0, 0, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = p2.contentText,
					fontStyle = v6.Typography.BodyMedium,
					textStyle = v6.Color.Content.Muted,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.XY,
					LayoutOrder = 2
				})
			}
		)
	end

	return nil
end

local function LicenseLabel(props)
	local v6 = useTokens()

	if props.headerText and props.contentText then
		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			HeaderText = React.createElement(text, {
				Size = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = props.headerText,
				fontStyle = v6.Typography.BodySmall,
				textStyle = v6.Color.Content.Emphasis,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = 1
			}),
			ContentText = React.createElement(text, {
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = props.contentText,
				fontStyle = v6.Typography.BodySmall,
				textStyle = v6.Color.Content.Muted,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 2
			})
		})
	end

	return nil
end

local function getLicenseList()
	local success, result = pcall(function()
		local coreScripts = InsertService:LoadLocalAsset("rbxasset://models/Licenses/Licenses.rbxm"):FindFirstChild("CoreScripts")
		local result2 = {}

		for i, child in pairs(coreScripts:GetChildren()) do
			assert(string.match(child.Name, "^(%d*)-(.*)") ~= nil, "Invalid license name")

			local v6 = string.split(child.Name, "-")
			local v7 = table.remove(v6, 1)
			local joined = table.concat(v6, "-")

			local v8 = string.gsub(child.Value, "\n*$", "")

			result2[v7 + 1] = { name = joined, text = v8 }
		end

		return result2
	end)

	return success and result or {}
end

local function AppInformationPage(props)
	local v6 = useTokens()

	local paddings = props.paddings
	assert(paddings, "paddings must not be nil")

	local paddingHorizontal = paddings.paddingHorizontal
	local paddingVertical = paddings.paddingVertical
	local contentMaxWidth = paddings.contentMaxWidth

	local children = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v6.Gap.Medium)
		}),
		SectionHeader = React.createElement(text, {
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = props.text.licenseHeader,
			Font = v6.Typography.BodyMedium.Font,
			TextSize = v6.Typography.BodyMedium.FontSize,
			LineHeight = v6.Typography.BodyMedium.LineHeight,
			TextColor3 = v6.Color.Content.Emphasis.Color3,
			TextTransparency = v6.Color.Content.Emphasis.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.XY,
			LayoutOrder = 1
		})
	}

	local v7 = React.useMemo(function()
		local success, result = pcall(function()
			local coreScripts = InsertService:LoadLocalAsset("rbxasset://models/Licenses/Licenses.rbxm"):FindFirstChild("CoreScripts")
			local result2 = {}

			for i, child in pairs(coreScripts:GetChildren()) do
				assert(string.match(child.Name, "^(%d*)-(.*)") ~= nil, "Invalid license name")

				local v8 = string.split(child.Name, "-")
				local v9 = table.remove(v8, 1)
				local joined = table.concat(v8, "-")

				local v10 = string.gsub(child.Value, "\n*$", "")

				result2[v9 + 1] = { name = joined, text = v10 }
			end

			return result2
		end)

		return success and result or {}
	end, {})

	for k, v8 in v7 do
		table.insert(children, React.createElement(LicenseLabel, {
			headerText = v8.name,
			contentText = v8.text,
			layoutOrder = k + 1
		}))
	end

	local element = React.createElement(
		module3,
		{
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.fromScale(1, 1),
			maxWidth = contentMaxWidth
		},
		{
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, paddingHorizontal),
				PaddingRight = UDim.new(0, paddingHorizontal),
				PaddingTop = UDim.new(0, paddingVertical),
				PaddingBottom = UDim.new(0, paddingVertical)
			}),
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			VersionInfo = React.createElement(
				"Frame",
				{
					AutomaticSize = Enum.AutomaticSize.XY,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 1
				},
				{
					Layout = React.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						Padding = UDim.new(0, v6.Padding.Medium)
					}),
					ClientCSVersionText = React.createElement(VersionLabel, {
						headerText = props.text.coreScriptVersionHeader,
						contentText = props.text.coreScriptVersion
					}),
					BuildVersionText = React.createElement(VersionLabel, {
						headerText = props.text.buildVersionHeader,
						contentText = props.text.buildVersion
					}),
					ClientChannelText = React.createElement(VersionLabel, {
						headerText = props.text.channelNameHeader,
						contentText = props.text.channelName
					})
				}
			),
			DividerContainer = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 2
			}, {
				Divider = React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = props.dividerStyle.Color,
					BackgroundTransparency = props.dividerStyle.Transparency,
					BorderSizePixel = 0
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v6.Gap.Large),
					PaddingBottom = UDim.new(0, v6.Gap.Medium)
				})
			}),
			LicenseInfo = React.createElement(
				"Frame",
				{
					AutomaticSize = Enum.AutomaticSize.XY,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 3
				},
				children
			)
		}
	)

	return React.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = props.backgroundStyle.Color,
			BackgroundTransparency = props.backgroundStyle.Transparency
		},
		{
			TopBar = React.createElement(module2.Container, {
				leftItem = module2.BackButton
			}),
			PageContent = React.createElement(module2.PageContent, {}, {
				PageContent = element
			})
		}
	)
end

local function AppInformation(p2)
	return module({
		licenseHeader = "CommonUI.Features.Label.Licensing",
		buildVersionHeader = {
			"CommonUI.Features.Label.VersionWithNumber",
			versionNumber = ""
		},
		channelNameHeader = {
			"CommonUI.Features.Label.ChannelWithChannelName",
			channelName = ""
		},
		coreScriptVersionHeader = {
			"CommonUI.Features.Label.ClientCoreScriptVersion",
			clientCoreScriptVersion = ""
		}
	})(function(p3)
		local joined = Cryo.Dictionary.join(p3, {
			buildVersion = v5,
			channelName = robloxClientChannel,
			coreScriptVersion = coreScriptVersion
		})

		return withStyle(function(p4)
			return React.createElement(AppInformationPage, {
				paddings = p2.paddings,
				backgroundStyle = p4.Theme.BackgroundDefault,
				dividerStyle = p4.Theme.Divider,
				text = joined
			})
		end)
	end)
end

return module4(AppInformation)
