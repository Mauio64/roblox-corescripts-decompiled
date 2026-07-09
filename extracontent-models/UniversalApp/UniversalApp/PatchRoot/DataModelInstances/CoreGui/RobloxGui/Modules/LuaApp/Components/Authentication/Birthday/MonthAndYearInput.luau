local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local TextInputBoxWithBorder = AuthCommon.Components.TextInputBoxWithBorder
local AuthStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder
local MonthDropdown = require(Modules.LuaApp.Components.Authentication.Birthday.MonthDropdown)
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization

return function(t1: {[any]: any}) -- line: 30
	-- upvalues: useStyle (copy), useLocalization (copy), React (copy), AuthStatefulRoundCornerBorder (copy), MonthDropdown (copy), TextInputBoxWithBorder (copy)
	local v12 = useStyle()
	local v13 = useLocalization({
		Year = "CommonUI.Controls.Label.Year",
		Birthday = "Authentication.SignUp.Label.Birthday"
	})
	local v14, v15 = React.useState(0)
	local v16, v17 = React.useState("")
	local v18, v19 = React.useState(false)
	local v20, v21 = React.useState(false)

	React.useEffect(function() -- line: 81
		-- upvalues: v18 (copy), v14 (copy), t1 (copy), v16 (copy)
		if v18 and v14 > 0 then
			t1.onMonthAndYearChange(v14, (tonumber(v16)))
		end
	end, {
		v14,
		v16,
		v18
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 0)
		}),
		InputFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDim.new(0, 0)
			}),
			MonthFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				ZIndex = 2,
				Size = UDim2.new(0.5, -18, 0, t1.textInputHeight + 24)
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 2)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 6)
				}),
				Label = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 0,
					Text = v13.Birthday,
					Font = v12.Font.CaptionHeader.Font,
					TextSize = v12.Font.BaseSize * v12.Font.CaptionHeader.RelativeSize,
					TextColor3 = v12.Theme.TextEmphasis.Color,
					TextTransparency = v12.Theme.TextEmphasis.Transparency,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				MonthDropdown = React.createElement(MonthDropdown, {
					layoutOrder = 1,
					shouldExpandRight = true,
					size = UDim2.new(1, 0, 0, t1.textInputHeight),
					textInputHeight = t1.textInputHeight,
					onMonthSelected = function(p1) -- line: 53
						-- upvalues: v15 (copy), t1 (copy)
						v15(p1)
						t1.onMonthInputConfirmed()
					end,
					screenSize = t1.screenSize
				})
			}),
			Padding = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(0, 36, 0, t1.textInputHeight + 24)
			}),
			YearFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.new(0.5, -18, 0, t1.textInputHeight + 24)
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 22)
				}),
				YearInput = React.createElement(TextInputBoxWithBorder, {
					textInputListPadding = 6,
					layoutOrder = 2,
					textInputType = Enum.TextInputType.Number,
					textInputHeight = t1.textInputHeight,
					placeholderText = v13.Year,
					borderState = if t1.errorText == "" then if not v20 then AuthStatefulRoundCornerBorder.BorderState.Default else AuthStatefulRoundCornerBorder.BorderState.Focused else AuthStatefulRoundCornerBorder.BorderState.Error,
					onChangeTextCallback = function(_) -- line: 58
						-- upvalues: v18 (copy), v19 (copy), t1 (copy), v17 (copy)
						if not v18 then
							v19(true)
						end

						if t1.textBoxRef and t1.textBoxRef.current then
							local currentText = t1.textBoxRef.current.Text

							if string.len(currentText) > 2 then
								t1.textBoxRef.current.Text = string.sub(currentText, 1, 2)
							end
						end

						v17(t1.textBoxRef.current.Text)
					end,
					onFocused = function() -- line: 71
						-- upvalues: v21 (copy), t1 (copy)
						v21(true)
						t1.onFocused()
					end,
					onFocusLost = function() -- line: 76
						-- upvalues: v21 (copy), t1 (copy)
						v21(false)
						t1.onFocusLost()
					end,
					textBoxRef = t1.textBoxRef
				})
			})
		}),
		ErrorText = t1.errorText ~= "" and React.createElement("TextLabel", {
			TextWrapped = true,
			BackgroundTransparency = 1,
			ZIndex = 0,
			LayoutOrder = 2,
			Text = t1.errorText,
			Font = v12.Font.CaptionBody.Font,
			TextSize = v12.Font.BaseSize * v12.Font.CaptionBody.RelativeSize,
			TextColor3 = v12.Theme.Alert.Color,
			TextTransparency = v12.Theme.TextDefault.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}),
		ValuePropPadding = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = if t1.errorText ~= "" then UDim2.new(0, 0, 0, 6) else UDim2.new(0, 0, 0, 21)
		})
	})
end
