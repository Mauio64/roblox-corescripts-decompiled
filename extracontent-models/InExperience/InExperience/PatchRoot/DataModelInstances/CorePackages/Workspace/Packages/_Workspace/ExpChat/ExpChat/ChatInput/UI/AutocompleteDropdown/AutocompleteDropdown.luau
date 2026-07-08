local ExpChat = script:FindFirstAncestor("ExpChat")
local TextChatService = game:GetService("TextChatService")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local useStyle = require(ExpChatParent.UIBlox).Core.Style.useStyle
local List = require(ExpChatParent.llama).List
local Dictionary = require(ExpChatParent.llama).Dictionary
local Config = require(ExpChat.Config)
local FFlagExpChatEnableFocusNavigation = require(ExpChat.Flags.FFlagExpChatEnableFocusNavigation)
local AutocompleteEntry = require(script.Parent.AutocompleteEntry)

local function AutoCompleteDropdown(p1) -- line: 20
	-- upvalues: React (copy), useStyle (copy), Dictionary (copy), AutocompleteEntry (copy), List (copy), Config (copy), TextChatService (copy), FFlagExpChatEnableFocusNavigation (copy)
	local v13 = React.useRef(nil)
	local Theme = useStyle().Theme
	local v15 = React.useCallback(function(p2) -- line: 26
		-- upvalues: Dictionary (copy), React (copy), AutocompleteEntry (copy), p1 (copy), List (copy)
		local v24 = Dictionary.map(p2, function(p3, p4) -- line: 27
			-- upvalues: React (copy), AutocompleteEntry (copy), p1 (copy), List (copy), p2 (copy)
			return React.createElement(AutocompleteEntry, {
				result = p3,
				layoutOrder = p4,
				chatInputBarSettings = p1.chatInputBarSettings,
				setTransparency = p1.setTransparency,
				transparencyValue = p1.transparencyValue,
				isDividerVisible = p4 ~= List.count(p2),
				selectedIndex = p1.selectedIndex,
				autocompleteType = p1.autocompleteType,
				onAutocompleteDropdownHover = p1.onAutocompleteDropdownHover,
				onAutocompleteSelected = p1.onAutocompleteSelected
			}), p3
		end)

		v24["$layout"] = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		return v24
	end)

	local function setCanvasPosition() -- line: 51
		-- upvalues: v13 (copy), p1 (copy), Config (copy)
		if v13.current then
			local current = p1.autocompleteDropdownRef.current
			local v26 = current and current.AbsoluteSize.Y or Config.AutocompleteFrameDefaultSizeY
			local v27 = p1.chatInputBarSettings.TextSize + 16
			local n1 = 0

			if current and current:FindFirstChild("ScrollBarFrame") and current.ScrollBarFrame:FindFirstChild("ScrollViewFrame") and current.ScrollBarFrame.ScrollViewFrame:FindFirstChild("ScrollView") and current.ScrollBarFrame.ScrollViewFrame.ScrollView:FindFirstChild("OffsetFrame") then
				local OffsetFrame = current.ScrollBarFrame.ScrollViewFrame.ScrollView.OffsetFrame

				for _, child in ipairs(OffsetFrame:GetChildren()) do
					if child.ClassName == "Frame" and child.LayoutOrder <= p1.selectedIndex then
						n1 += child.AbsoluteSize.Y

						if child.LayoutOrder == p1.selectedIndex then
							v27 = child.AbsoluteSize.Y
						end
					end
				end
			end

			local CanvasPositionY = v13.current.CanvasPosition.Y
			local v33 = CanvasPositionY + v26
			local v34 = n1 - v27
			local v35 = CanvasPositionY

			if v33 < n1 then
				v35 = n1 - v26
			end

			if v34 < CanvasPositionY then
				v35 = v34
			end

			return Vector2.new(0, v35)
		end

		return Vector2.new(0, 0)
	end

	local VerticalAlignment = nil
	local v18 = false
	local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")

	if ChatWindowConfiguration then
		VerticalAlignment = ChatWindowConfiguration.VerticalAlignment
		v18 = ChatWindowConfiguration.Enabled
	end

	local v20 = VerticalAlignment == Enum.VerticalAlignment.Top and not v18
	local v21 = p1.textBoxRef.current and p1.textBoxRef.current.AbsoluteSize.Y + 20
	local v22 = p1.autocompleteDropdownRef.current and (not not p1.autocompleteDropdownRef.current:FindFirstAncestor("appLayout") and p1.autocompleteDropdownRef.current:FindFirstAncestor("appLayout"):FindFirstChild("chatWindow")) or nil

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		AnchorPoint = v20 and Vector2.new(0, 0) or Vector2.new(0, 1),
		Size = UDim2.new(0.95, 0, 0, #p1.results > 3 and Config.AutocompleteFrameDefaultSizeY or #p1.results * Config.AutocompleteEntryDefaultSizeY),
		Position = UDim2.new(0, 0, 0, v20 and v21 or 0),
		Visible = p1.activated and #p1.results > 0,
		ref = p1.autocompleteDropdownRef
	}, {
		UISizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(Config.ChatWindowMaxWidth, v22 and (not v20 and v22.AbsoluteSize.Y) or 1e999)
		}),
		ScrollBarFrame = React.createElement("Frame", {
			ZIndex = 2,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = p1.setTransparency(0, p1.transparencyValue),
			BackgroundColor3 = p1.chatInputBarSettings.BackgroundColor3
		}, {
			Border = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Config.ChatInputBarBorderColor3,
				Transparency = p1.setTransparency(Config.ChatInputBarBorderTransparency, p1.transparencyValue)
			}),
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 3)
			}),
			ScrollViewFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1)
			}, {
				ScrollView = React.createElement("ScrollingFrame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 4,
					ClipsDescendants = false,
					ZIndex = 2,
					Size = UDim2.new(1, -4, 1, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(0, 0, 0, #p1.results * Config.AutocompleteEntryDefaultSizeY),
					CanvasPosition = setCanvasPosition(),
					ScrollBarImageColor3 = Theme.UIEmphasis.Color,
					ScrollBarImageTransparency = p1.setTransparency(0, p1.transparencyValue),
					VerticalScrollBarInset = Enum.ScrollBarInset.Always,
					Selectable = not FFlagExpChatEnableFocusNavigation,
					ref = v13
				}, {
					OffsetFrame = React.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 8, 1, 0)
					}, v15(p1.results))
				})
			})
		})
	})
end

return React.memo(AutoCompleteDropdown)
