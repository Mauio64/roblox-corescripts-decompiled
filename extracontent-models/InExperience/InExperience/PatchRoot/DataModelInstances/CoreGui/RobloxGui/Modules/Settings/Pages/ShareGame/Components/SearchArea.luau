local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local GetFFlagShareGameSearchBoxFocusAnalytics = require(RobloxGui.Modules.Settings.Flags.GetFFlagShareGameSearchBoxFocusAnalytics)
local SearchBox = require(ShareGame.Components.SearchBox)
local IconButton = require(ShareGame.Components.IconButton)
local Constants = require(ShareGame.Constants)
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local Theme = require(RobloxGui.Modules.Settings.Theme)
local SetSearchAreaActive = require(ShareGame.Actions.SetSearchAreaActive)
local SetSearchText = require(ShareGame.Actions.SetSearchText)
local ShareGameIcons = require(RobloxGui.Modules.Settings.Pages.ShareGame.Spritesheets.ShareGameIcons)
local v15 = require(ShareGame.getTranslator)()
local ImagePath = ShareGameIcons:GetImagePath()
local Frame = ShareGameIcons:GetFrame("search_large")
local v18 = Theme.font(Enum.Font.SourceSans)
local GRAY3 = Constants.Color.GRAY3
local v20 = Theme.textSize(20)
local v21 = Roact.PureComponent:extend("SearchArea")

function v21.init(p1) -- line: 38
	-- upvalues: v15 (copy)
	p1.state = {
		cancelText = v15:FormatByKey("Feature.SettingsHub.Action.CancelSearch")
	}
	p1.searchField = nil
end
function v21.render(p2) -- line: 45
	-- upvalues: Text (copy), v18 (copy), v20 (copy), Roact (copy), IconButton (copy), ImagePath (copy), Frame (copy), SearchBox (copy), GetFFlagShareGameSearchBoxFocusAnalytics (copy), GRAY3 (copy)
	local fullWidthSearchBar = p2.props.fullWidthSearchBar
	local searchBoxMargin = p2.props.searchBoxMargin
	local anchorPoint = p2.props.anchorPoint
	local position = p2.props.position
	local zIndex = p2.props.zIndex
	local searchAreaActive = p2.props.searchAreaActive
	local size = p2.props.size
	local cancelText = p2.state.cancelText
	local v32 = Text.GetTextWidth(cancelText, v18, v20)
	local v33 = searchBoxMargin + v32
	local setSearchText = p2.props.setSearchText

	if fullWidthSearchBar then
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = anchorPoint,
			Position = position,
			Size = size,
			ZIndex = zIndex
		}, {
			SearchButton = Roact.createElement(IconButton, {
				visible = not searchAreaActive,
				anchorPoint = anchorPoint,
				position = position,
				size = UDim2.new(0, 44, 0, 44),
				zIndex = zIndex,
				iconHorizontalAlignment = Enum.HorizontalAlignment.Right,
				iconSpritePath = ImagePath,
				iconSpriteFrame = Frame,
				onClick = function(_) -- line: 82
					-- upvalues: p2 (copy)
					p2.props.setSearchAreaActive(true)
				end
			}),
			SearchBox = Roact.createElement(SearchBox, {
				anchorPoint = Vector2.new(0, 0.5),
				position = UDim2.new(0, 0, 0.5, 0),
				size = UDim2.new(1, -v33, 0, 28),
				zIndex = zIndex,
				visible = searchAreaActive,
				modalFocused = searchAreaActive,
				onTextChanged = setSearchText,
				onTextBoxFocused = function() -- line: 96
					-- upvalues: GetFFlagShareGameSearchBoxFocusAnalytics (copy), p2 (copy)
					if GetFFlagShareGameSearchBoxFocusAnalytics() and p2.props.analytics then
						p2.props.analytics:onSearchFocused()
					end
				end,
				onTextBoxFocusLost = function(p4) -- line: 101
					-- upvalues: p2 (copy)
					if p4 == "" then
						p2.props.setSearchAreaActive(false)
					end
				end,
				searchFieldRef = function(p5) -- line: 106
					-- upvalues: p2 (copy)
					p2.searchField = p5
				end
			}),
			Cancel = Roact.createElement("TextButton", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.new(0, v32, 1, 0),
				TextSize = v20,
				TextColor3 = GRAY3,
				Font = v18,
				ZIndex = zIndex,
				Visible = searchAreaActive,
				[Roact.Ref] = function(p6) -- line: 121
					-- upvalues: cancelText (copy), p2 (copy)
					if p6 then
						p6.Text = cancelText

						if not p2.textConnection then
							p2.textConnection = p6:GetPropertyChangedSignal("Text"):connect(function() -- line: 131
								-- upvalues: p2 (copy), p6 (copy)
								p2:setState({
									cancelText = p6.Text
								})
							end)
						end
					end
				end,
				[Roact.Event.Activated] = function(_) -- line: 139
					-- upvalues: p2 (copy)
					p2.props.setSearchAreaActive(false)
				end
			})
		})
	end

	return Roact.createElement(SearchBox, {
		anchorPoint = Vector2.new(1, 0.5),
		position = UDim2.new(1, 0, 0.5, 0),
		size = UDim2.new(0, 177, 0, 28),
		zIndex = zIndex,
		onTextChanged = setSearchText,
		searchFieldRef = function(p8) -- line: 155
			-- upvalues: p2 (copy)
			p2.searchField = p8
		end
	})
end
function v21.didUpdate(p9, p10) -- line: 162
	local fullWidthSearchBar = p9.props.fullWidthSearchBar

	if p9.searchField then
		if not p9.props.isPageOpen and p10.isPageOpen then
			spawn(function() -- line: 170
				-- upvalues: fullWidthSearchBar (copy), p9 (copy)
				if fullWidthSearchBar then
					p9.props.setSearchAreaActive(false)

					return
				end

				p9.searchField.Text = ""
			end)
		end

		if fullWidthSearchBar then
			local searchAreaActive = p9.props.searchAreaActive
			local searchAreaActive2 = p10.searchAreaActive

			if searchAreaActive and not searchAreaActive2 then
				p9.searchField:CaptureFocus()

				return
			end

			if not searchAreaActive and searchAreaActive2 then
				p9.searchField.Text = ""
			end
		end
	end
end

return (RoactRodux.UNSTABLE_connect2(function(p11, _) -- line: 194
	return {
		isPageOpen = p11.Page.IsOpen,
		searchAreaActive = p11.ConversationsSearch.SearchAreaActive
	}
end, function(p13) -- line: 199
	-- upvalues: SetSearchAreaActive (copy), SetSearchText (copy)
	return {
		setSearchAreaActive = function(p14) -- line: 201
			-- upvalues: p13 (copy), SetSearchAreaActive (copy)
			p13(SetSearchAreaActive(p14))
		end,
		setSearchText = function(p15) -- line: 204
			-- upvalues: p13 (copy), SetSearchText (copy)
			p13(SetSearchText(p15))
		end
	}
end)(v21))
