local CorePackages = game:GetService("CorePackages")
local InsertService = game:GetService("InsertService")
local RunService = game:GetService("RunService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local MorePageScrollingFrame = require(Modules.LuaApp.Components.More.MorePageScrollingFrame)
local withMorePagePaddings = require(Modules.LuaApp.Components.More.withMorePagePaddings)
local RobloxClientChannel = RunService:GetRobloxClientChannel()
local RobloxVersion = RunService:GetRobloxVersion()
local CoreScriptVersion = RunService:GetCoreScriptVersion()
local ClientGitHash = RunService.ClientGitHash
local u19 = string.format("%s (%.6s)", RobloxVersion, ClientGitHash)

local function VersionLabel(p1) -- line: 41
	-- upvalues: useTokens (copy), React (copy), FoundationText (copy)
	local v26 = useTokens()

	if not p1.headerText or not p1.contentText then
		return nil
	end

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		Layout = React.createElement("UIListLayout", {
			Wraps = true,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal
		}),
		HeaderText = React.createElement(FoundationText, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.new(0, 0, 0, 0),
			Text = p1.headerText,
			fontStyle = v26.Typography.BodyMedium,
			textStyle = v26.Color.Content.Emphasis,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.XY
		}),
		ContentText = React.createElement(FoundationText, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = UDim2.new(0, 0, 0, 0),
			Text = p1.contentText,
			fontStyle = v26.Typography.BodyMedium,
			textStyle = v26.Color.Content.Muted,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.XY
		})
	})
end
local function LicenseLabel(p2) -- line: 81
	-- upvalues: useTokens (copy), React (copy), FoundationText (copy)
	local v28 = useTokens()

	if not p2.headerText or not p2.contentText then
		return nil
	end

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = p2.layoutOrder
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}),
		HeaderText = React.createElement(FoundationText, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.new(0, 0, 0, 0),
			Text = p2.headerText,
			fontStyle = v28.Typography.BodySmall,
			textStyle = v28.Color.Content.Emphasis,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.XY
		}),
		ContentText = React.createElement(FoundationText, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextWrapped = true,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			Text = p2.contentText,
			fontStyle = v28.Typography.BodySmall,
			textStyle = v28.Color.Content.Muted,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y
		})
	})
end
local function getLicenseList() -- line: 123
	-- upvalues: InsertService (copy)
	local ok, result = pcall(function() -- line: 126
		-- upvalues: InsertService (copy)
		local t1 = {}
		local CoreScripts = InsertService:LoadLocalAsset("rbxasset://models/Licenses/Licenses.rbxm"):FindFirstChild("CoreScripts")

		for _, child in pairs(CoreScripts:GetChildren()) do
			assert(string.match(child.Name, "^(%d*)-(.*)") ~= nil, "Invalid license name")

			local parts = string.split(child.Name, "-")
			local v47 = table.remove(parts, 1)
			local v48 = table.concat(parts, "-")
			local v49 = string.gsub(child.Value, "\n*$", "")

			t1[v47 + 1] = {
				name = v48,
				text = v49
			}
		end

		return t1
	end)

	return ok and result or {}
end
local function AppInformationPage(p3) -- line: 157
	-- upvalues: useTokens (copy), React (copy), FoundationText (copy), InsertService (copy), LicenseLabel (copy), MorePageScrollingFrame (copy), VersionLabel (copy), TopBar (copy)
	local v32 = useTokens()
	local paddings = p3.paddings

	assert(paddings, "paddings must not be nil")

	local paddingHorizontal = paddings.paddingHorizontal
	local paddingVertical = paddings.paddingVertical
	local contentMaxWidth = paddings.contentMaxWidth
	local t2 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v32.Gap.Medium)
		}),
		SectionHeader = React.createElement(FoundationText, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.new(0, 0, 0, 0),
			Text = p3.text.licenseHeader,
			Font = v32.Typography.BodyMedium.Font,
			TextSize = v32.Typography.BodyMedium.FontSize,
			LineHeight = v32.Typography.BodyMedium.LineHeight,
			TextColor3 = v32.Color.Content.Emphasis.Color3,
			TextTransparency = v32.Color.Content.Emphasis.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.XY
		})
	}

	for v38, v39 in (React.useMemo(function() -- line: 188
		-- upvalues: InsertService (copy)
		local ok, result = pcall(function() -- line: 126
			-- upvalues: InsertService (copy)
			local t3 = {}
			local CoreScripts = InsertService:LoadLocalAsset("rbxasset://models/Licenses/Licenses.rbxm"):FindFirstChild("CoreScripts")

			for _, child in pairs(CoreScripts:GetChildren()) do
				assert(string.match(child.Name, "^(%d*)-(.*)") ~= nil, "Invalid license name")

				local parts = string.split(child.Name, "-")
				local v59 = table.remove(parts, 1)
				local v60 = table.concat(parts, "-")
				local v61 = string.gsub(child.Value, "\n*$", "")

				t3[v59 + 1] = {
					name = v60,
					text = v61
				}
			end

			return t3
		end)

		return ok and result or {}
	end, {})) do
		table.insert(t2, React.createElement(LicenseLabel, {
			headerText = v39.name,
			contentText = v39.text,
			layoutOrder = v38 + 1
		}))
	end

	local v40 = React.createElement(MorePageScrollingFrame, {
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),
		maxWidth = contentMaxWidth
	}, {
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
		VersionInfo = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			Layout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, v32.Padding.Medium)
			}),
			ClientCSVersionText = React.createElement(VersionLabel, {
				headerText = p3.text.coreScriptVersionHeader,
				contentText = p3.text.coreScriptVersion
			}),
			BuildVersionText = React.createElement(VersionLabel, {
				headerText = p3.text.buildVersionHeader,
				contentText = p3.text.buildVersion
			}),
			ClientChannelText = React.createElement(VersionLabel, {
				headerText = p3.text.channelNameHeader,
				contentText = p3.text.channelName
			})
		}),
		DividerContainer = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Divider = React.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = p3.dividerStyle.Color,
				BackgroundTransparency = p3.dividerStyle.Transparency
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v32.Gap.Large),
				PaddingBottom = UDim.new(0, v32.Gap.Medium)
			})
		}),
		LicenseInfo = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			AutomaticSize = Enum.AutomaticSize.XY
		}, t2)
	})

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = p3.backgroundStyle.Color,
		BackgroundTransparency = p3.backgroundStyle.Transparency
	}, {
		TopBar = React.createElement(TopBar.Container, {
			leftItem = TopBar.BackButton
		}),
		PageContent = React.createElement(TopBar.PageContent, {}, {
			PageContent = v40
		})
	})
end
local function AppInformation(p4) -- line: 280
	-- upvalues: withLocalization (copy), Cryo (copy), u19 (ref), RobloxClientChannel (copy), CoreScriptVersion (copy), withStyle (copy), React (copy), AppInformationPage (copy)
	return withLocalization({
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
	})(function(p5) -- line: 288
		-- upvalues: Cryo (copy), u19 (ref), RobloxClientChannel (copy), CoreScriptVersion (copy), withStyle (copy), React (copy), AppInformationPage (copy), p4 (copy)
		local v53 = Cryo.Dictionary.join(p5, {
			buildVersion = u19,
			channelName = RobloxClientChannel,
			coreScriptVersion = CoreScriptVersion
		})

		return withStyle(function(p6) -- line: 294
			-- upvalues: React (copy), AppInformationPage (copy), p4 (copy), v53 (copy)
			return React.createElement(AppInformationPage, {
				paddings = p4.paddings,
				backgroundStyle = p6.Theme.BackgroundDefault,
				dividerStyle = p6.Theme.Divider,
				text = v53
			})
		end)
	end)
end

return withMorePagePaddings(AppInformation)
