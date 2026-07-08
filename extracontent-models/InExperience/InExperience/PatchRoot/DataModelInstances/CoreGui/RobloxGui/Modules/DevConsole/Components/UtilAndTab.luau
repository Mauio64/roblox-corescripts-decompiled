local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(script.Parent.Parent.Constants)
local FrameHeight = Constants.TabRowFormatting.FrameHeight
local TabDropDownWidth = Constants.TabRowFormatting.TabDropDownWidth
local TabOverlapThreshold = Constants.TabRowFormatting.TabOverlapThreshold
local FrameHeight2 = Constants.UtilityBarFormatting.FrameHeight
local SmallFrameHeight = Constants.UtilityBarFormatting.SmallFrameHeight
local SmallUtilPadding = Constants.UtilityBarFormatting.SmallUtilPadding
local ClientServerButtonWidth = Constants.UtilityBarFormatting.ClientServerButtonWidth
local ClientServerDropDownWidth = Constants.UtilityBarFormatting.ClientServerDropDownWidth
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding
local scriptParent = script.Parent
local ClientServerButton = require(scriptParent.ClientServerButton)
local CheckboxContainer = require(scriptParent.CheckboxContainer)
local TabRowContainer = require(scriptParent.TabRowContainer)
local SearchBar = require(scriptParent.SearchBar)
local v19 = Roact.Component:extend("UtilAndTab")

function v19.init(p1) -- line: 29
	-- upvalues: TextService (copy), Constants (copy), Roact (copy)
	local tabList = p1.props.tabList
	local n1 = 0
	local n2 = 0

	for k, _ in pairs(tabList) do
		n1 += TextService:GetTextSize(k, Constants.DefaultFontSize.TabBar, Constants.Font.TabBar, Vector2.new(0, 0)).X
		n2 += 1
	end

	function p1.showSearchBar() -- line: 41
		-- upvalues: p1 (copy)
		p1:setState({
			activeSearchTerm = true
		})
	end
	function p1.cancelInput(_, p3) -- line: 47
		-- upvalues: p1 (copy)
		if p3.UserInputType == Enum.UserInputType.MouseButton1 or p3.UserInputType == Enum.UserInputType.Touch and p3.UserInputState == Enum.UserInputState.End then
			if p1.searchRef.current then
				p1.searchRef.current.Text = ""
			end

			local onSearchTermChanged = p1.props.onSearchTermChanged

			if onSearchTermChanged then
				onSearchTermChanged("")
			end

			p1:setState({
				activeSearchTerm = false
			})
		end
	end
	function p1.focusLost(p4, p5, _) -- line: 68
		-- upvalues: p1 (copy)
		if p5 then
			local text = p4.text
			local onSearchTermChanged = p1.props.onSearchTermChanged

			if onSearchTermChanged then
				onSearchTermChanged(text)
			end

			local v60 = text ~= ""

			if v60 ~= p1.state.activeSearchTerm then
				p1:setState({
					activeSearchTerm = v60
				})
			end
		end
	end

	p1.state = {
		activeSearchTerm = false,
		totalTabWidth = n1,
		totalTabCount = n2
	}
	p1.utilRef = Roact.createRef()
	p1.searchRef = Roact.createRef()
end
function v19.render(p7) -- line: 94
	-- upvalues: TabOverlapThreshold (copy), Constants (copy), SmallFrameHeight (copy), FrameHeight2 (copy), Roact (copy), ClientServerButtonWidth (copy), MainRowPadding (copy), SmallUtilPadding (copy), TabDropDownWidth (copy), ClientServerDropDownWidth (copy), TextService (copy), TabRowContainer (copy), ClientServerButton (copy), CheckboxContainer (copy), SearchBar (copy), FrameHeight (copy)
	local windowWidth = p7.props.windowWidth
	local formFactor = p7.props.formFactor
	local tabList = p7.props.tabList
	local orderedCheckboxState = p7.props.orderedCheckboxState
	local layoutOrder = p7.props.layoutOrder
	local isClientView = p7.props.isClientView
	local searchTerm = p7.props.searchTerm
	local onClientButton = p7.props.onClientButton
	local onServerButton = p7.props.onServerButton
	local onCheckboxChanged = p7.props.onCheckboxChanged
	local onSearchTermChanged = p7.props.onSearchTermChanged
	local totalTabWidth = p7.state.totalTabWidth
	local totalTabCount = p7.state.totalTabCount
	local activeSearchTerm = p7.state.activeSearchTerm
	local v41 = (windowWidth - totalTabWidth) / totalTabCount < TabOverlapThreshold and windowWidth > 0
	local v42 = formFactor == Constants.FormFactor.Small and SmallFrameHeight or FrameHeight2
	local v43 = formFactor ~= Constants.FormFactor.Small and 7 or 6
	local v44 = p7.props[Roact.Children] and math.ceil(#p7.props[Roact.Children] / 5) or 1
	local v45 = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -v43 * ClientServerButtonWidth - MainRowPadding, 0, 0),
		Size = UDim2.new(0, 5 * ClientServerButtonWidth, 0, v42 * v44)
	}, {
		Layout = Roact.createElement("UIGridLayout", {
			FillDirectionMaxCells = 5,
			CellPadding = UDim2.new(0, MainRowPadding, 0, 0),
			CellSize = UDim2.new(0, ClientServerButtonWidth, 0, v42),
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		unpack(p7.props[Roact.Children] or {})
	})

	if formFactor == Constants.FormFactor.Small or v41 then
		local v46 = SmallFrameHeight * v44 + SmallUtilPadding

		if activeSearchTerm then
			v46 = v46 + SmallFrameHeight + SmallUtilPadding
		end

		local v47 = onClientButton and onServerButton
		local v48 = windowWidth - SmallFrameHeight - TabDropDownWidth

		if v47 then
			v48 -= ClientServerDropDownWidth
		end

		local v49 = TextService:GetTextSize("Cancel", Constants.DefaultFontSize.UtilBar, Constants.Font.UtilBar, Vector2.new(0, 0)).X + 12

		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, v46),
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder,
			[Roact.Ref] = p7.props.refForParent
		}, {
			MainFrame = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, SmallFrameHeight),
				BackgroundTransparency = 1,
				[Roact.Ref] = p7.utilRef
			}, {
				MainRow = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0, SmallUtilPadding)
					}),
					Tabs = Roact.createElement(TabRowContainer, {
						layoutOrder = 1,
						tabList = tabList,
						windowWidth = windowWidth,
						frameHeight = SmallFrameHeight,
						formFactor = formFactor
					}),
					ClientServerButton = v47 and Roact.createElement(ClientServerButton, {
						layoutOrder = 2,
						frameHeight = SmallFrameHeight,
						formFactor = formFactor,
						useDropDown = v41,
						isClientView = isClientView,
						onClientButton = onClientButton,
						onServerButton = onServerButton
					}),
					FilterCheckboxes = onCheckboxChanged and Roact.createElement(CheckboxContainer, {
						layoutOrder = 3,
						orderedCheckboxState = orderedCheckboxState,
						frameWidth = v48,
						frameHeight = SmallFrameHeight,
						pos = UDim2.new(0, 2 * ClientServerButtonWidth + MainRowPadding, 0, 0),
						onCheckboxChanged = onCheckboxChanged
					})
				}),
				SearchButton = Roact.createElement("ImageButton", {
					Size = UDim2.new(0, SmallFrameHeight, 0, SmallFrameHeight),
					Position = UDim2.new(1, -SmallFrameHeight, 0, 0),
					BackgroundTransparency = 1,
					Image = Constants.Image.Search,
					Visible = not activeSearchTerm,
					[Roact.Event.Activated] = p7.showSearchBar
				}),
				Buttons = v45
			}),
			SearchBarFrame = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, SmallFrameHeight),
				Position = UDim2.new(0, 0, 0, (SmallFrameHeight + SmallUtilPadding) * v44),
				Visible = activeSearchTerm
			}, {
				SearchBar = Roact.createElement(SearchBar, {
					size = UDim2.new(1, -v49, 0, SmallFrameHeight),
					searchTerm = searchTerm,
					showClear = activeSearchTerm,
					textSize = Constants.DefaultFontSize.Search,
					font = Constants.Font.Search,
					frameHeight = SmallFrameHeight,
					refForParent = p7.searchRef,
					cancelInput = p7.cancelInput,
					focusLost = p7.focusLost
				}),
				CancelButton = Roact.createElement("TextButton", {
					Size = UDim2.new(0, v49, 1, 0),
					Position = UDim2.new(1, -v49, 0, 0),
					Text = "Cancel",
					TextSize = Constants.DefaultFontSize.UtilBar,
					TextColor3 = Constants.Color.Text,
					Font = Constants.Font.UtilBar,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					[Roact.Event.Activated] = p7.cancelInput
				})
			})
		})
	end

	local v50 = onClientButton and onServerButton
	local v51 = windowWidth - SmallUtilPadding * 3 - 3 * ClientServerButtonWidth

	if v50 then
		v51 -= ClientServerButtonWidth
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, FrameHeight + FrameHeight2 * v44 + MainRowPadding),
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		[Roact.Ref] = p7.props.refForParent
	}, {
		Tabs = Roact.createElement(TabRowContainer, {
			tabList = tabList,
			windowWidth = windowWidth,
			frameHeight = FrameHeight,
			formFactor = formFactor
		}),
		UtilBar = Roact.createElement("Frame", {
			Position = UDim2.new(0, 4, 0, FrameHeight + MainRowPadding),
			Size = UDim2.new(1, -8, 0, FrameHeight2),
			BackgroundTransparency = 1,
			[Roact.Ref] = p7.utilRef
		}, {
			MainRow = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, SmallUtilPadding)
				}),
				ClientServerButton = v50 and Roact.createElement(ClientServerButton, {
					formFactor = formFactor,
					isClientView = isClientView,
					onClientButton = onClientButton,
					onServerButton = onServerButton
				}),
				FilterCheckboxes = onCheckboxChanged and Roact.createElement(CheckboxContainer, {
					orderedCheckboxState = orderedCheckboxState,
					frameWidth = v51,
					frameHeight = FrameHeight2,
					pos = UDim2.new(0, 2 * ClientServerButtonWidth + MainRowPadding, 0, 0),
					onCheckboxChanged = onCheckboxChanged
				})
			}),
			SearchBar = onSearchTermChanged and Roact.createElement(SearchBar, {
				size = UDim2.new(0, 2 * ClientServerButtonWidth, 0, FrameHeight2),
				pos = UDim2.new(1, -2 * ClientServerButtonWidth, 0, 0),
				searchTerm = searchTerm,
				showClear = activeSearchTerm,
				textSize = Constants.DefaultFontSize.Search,
				font = Constants.Font.Search,
				frameHeight = Constants.UtilityBarFormatting.FrameHeight,
				refForParent = p7.searchRef,
				cancelInput = p7.cancelInput,
				focusLost = p7.focusLost
			}),
			Buttons = v45
		})
	})
end

return v19
