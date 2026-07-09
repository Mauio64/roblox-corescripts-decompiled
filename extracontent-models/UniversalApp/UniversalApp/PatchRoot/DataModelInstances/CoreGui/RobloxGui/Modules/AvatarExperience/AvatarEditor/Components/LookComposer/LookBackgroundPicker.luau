local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Focusable = RoactGamepad.Focusable
local Constants = require(Modules.AvatarExperience.Common.Constants)
local UpdateLookDetails = require(Modules.AvatarExperience.Common.Actions.UpdateLookDetails)
local DefaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local GridMetrics = UIBlox.App.Grid.GridMetrics
local useStyle = UIBlox.Core.Style.useStyle
local t1 = {
	Color3.fromHex("#584D43"),
	Color3.fromHex("#775D49"),
	Color3.fromHex("#AB9585"),
	Color3.fromHex("#C3916F"),
	Color3.fromHex("#E2BA97"),
	Color3.fromHex("#534338"),
	Color3.fromHex("#63422C"),
	Color3.fromHex("#B79C66"),
	Color3.fromHex("#C2AD7F"),
	Color3.fromHex("#D4C69F"),
	Color3.fromHex("#917A78"),
	Color3.fromHex("#98504E"),
	Color3.fromHex("#CE8A7D"),
	Color3.fromHex("#F7CBCA"),
	Color3.fromHex("#F19DD9"),
	Color3.fromHex("#77859B"),
	Color3.fromHex("#5B7BAA"),
	Color3.fromHex("#8DB9D9"),
	Color3.fromHex("#AFA7F9"),
	Color3.fromHex("#9D6298"),
	Color3.fromHex("#3E8D9A"),
	Color3.fromHex("#6A9855"),
	Color3.fromHex("#829B70"),
	Color3.fromHex("#A8C391"),
	Color3.fromHex("#D89E52"),
	Color3.fromHex("#EFCE53"),
	Color3.fromHex("#F3DA7D"),
	Color3.fromHex("#625F62"),
	Color3.fromHex("#CDCDCD"),
	Color3.fromHex("#F8F8F8")
}

local function LookBackgroundPicker() -- line: 57
	-- upvalues: useDispatch (copy), useStyle (copy), useDesignTokens (copy), useSelector (copy), Constants (copy), React (copy), Cryo (copy), UpdateLookDetails (copy), Focusable (copy), FFlagRenameDeprecatedUIBloxTokens (copy), DefaultMetricsGridView (copy), GridMetrics (copy), t1 (copy)
	local v19 = useDispatch()
	local v20 = useStyle()
	local v21 = useDesignTokens()
	local v22 = useSelector(function(p1) -- line: 62
		-- upvalues: Constants (copy)
		return p1.AvatarExperience.AvatarScene.Looks[Constants.DraftLookId]
	end)
	local v23 = React.useCallback(function(p2) -- line: 67
		-- upvalues: React (copy), v22 (copy), Cryo (copy), v19 (copy), UpdateLookDetails (copy), Constants (copy)
		return React.createElement("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = p2,
			Text = "",
			[React.Event.Activated] = function() -- line: 72
				-- upvalues: p2 (copy), v22 (copy), Cryo (copy), v19 (copy), UpdateLookDetails (copy), Constants (copy)
				local v27 = p2:ToHex()
				local v28 = if not v22 then {} else v22.displayProperties
				local v29 = Cryo.Dictionary.join(v28, {
					backgroundType = "Hex",
					backgroundValue = v27
				})

				v19(UpdateLookDetails(Constants.DraftLookId, {
					displayProperties = v29
				}))
			end
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			})
		})
	end, {
		v22,
		v19
	})

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		Header = React.createElement("TextLabel", {
			BorderSizePixel = 0,
			Text = "Select a background",
			TextWrapped = true,
			ZIndex = 2,
			Size = UDim2.new(1, 0, 0, if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Size_600 else v21.Size.Size_1200),
			BackgroundColor3 = v20.Theme.BackgroundDefault.Color,
			Font = v20.Font.Header2.Font,
			TextSize = v20.Font.BaseSize * v20.Font.Header2.RelativeSize,
			TextColor3 = v20.Theme.TextDefault.Color,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Size_150 else v21.Size.Size_300)
			})
		}),
		ScrollingFrame = React.createElement(Focusable.ScrollingFrame, {
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			BackgroundColor3 = v20.Theme.BackgroundDefault.Color,
			Position = UDim2.fromOffset(0, if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Size_600 else v21.Size.Size_1200),
			Size = UDim2.fromScale(1, 1),
			AutomaticCanvasSize = Enum.AutomaticSize.Y
		}, {
			Container = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Size_150 else v21.Size.Size_300),
					PaddingBottom = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Size_150 else v21.Size.Size_300),
					PaddingLeft = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Size_150 else v21.Size.Size_300),
					PaddingRight = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Size_150 else v21.Size.Size_300)
				}),
				BackgroundColorsGrid = React.createElement(DefaultMetricsGridView, {
					maxHeight = 1e999,
					defaultChildIndex = 1,
					renderItem = v23,
					getItemHeight = function(p3) -- line: 184
						return p3
					end,
					getItemMetrics = GridMetrics.makeCustomMetricsGetter({
						minimumItemsPerRow = 5,
						minimumItemWidth = 60
					}),
					itemPadding = Vector2.new(if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Size_125 else v21.Size.Size_250, if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Size_125 else v21.Size.Size_250),
					items = t1
				})
			})
		})
	})
end

return LookBackgroundPicker
