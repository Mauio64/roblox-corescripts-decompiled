local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame

local GetFFlagShareGameSearchBoxFocusAnalytics = require(RobloxGui.Modules.Settings.Flags.GetFFlagShareGameSearchBoxFocusAnalytics)
local SearchBox = require(ShareGame.Components.SearchBox)
local IconButton = require(ShareGame.Components.IconButton)
local Constants = require(ShareGame.Constants)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Text = AppCommonLib.Text
local Theme = require(RobloxGui.Modules.Settings.Theme)

local SetSearchAreaActive = require(ShareGame.Actions.SetSearchAreaActive)
local SetSearchText = require(ShareGame.Actions.SetSearchText)
local ShareGameIcons = require(RobloxGui.Modules.Settings.Pages.ShareGame.Spritesheets.ShareGameIcons)

local getTranslator = require(ShareGame.getTranslator)
local translator = getTranslator()

local imagePath = ShareGameIcons:GetImagePath()
local frame = ShareGameIcons:GetFrame("search_large")

local font = Theme.font(Enum.Font.SourceSans)
local GRAY3 = Constants.Color.GRAY3
local textSize = Theme.textSize(20)

local extended = Roact.PureComponent:extend("SearchArea")

function extended:init()
	self.state = {
		cancelText = translator:FormatByKey("Feature.SettingsHub.Action.CancelSearch")
	}

	self.searchField = nil
end

function extended:render()
	local fullWidthSearchBar = self.props.fullWidthSearchBar
	local searchBoxMargin = self.props.searchBoxMargin
	local anchorPoint = self.props.anchorPoint
	local position = self.props.position
	local zIndex = self.props.zIndex
	local searchAreaActive = self.props.searchAreaActive
	local size = self.props.size

	local cancelText = self.state.cancelText
	local textWidth = Text.GetTextWidth(cancelText, font, textSize)
	local v = searchBoxMargin + textWidth

	local setSearchText = self.props.setSearchText

	if not fullWidthSearchBar then
		return Roact.createElement(SearchBox, {
			anchorPoint = Vector2.new(1, 0.5),
			position = UDim2.new(1, 0, 0.5, 0),
			size = UDim2.new(0, 177, 0, 28),
			zIndex = zIndex,
			onTextChanged = setSearchText,
			searchFieldRef = function(searchField)
				self.searchField = searchField
			end
		})
	end

	return Roact.createElement("Frame", {
		AnchorPoint = anchorPoint,
		Position = position,
		Size = size,
		BackgroundTransparency = 1,
		ZIndex = zIndex
	}, {
		SearchButton = Roact.createElement(IconButton, {
			visible = not searchAreaActive,
			anchorPoint = anchorPoint,
			position = position,
			size = UDim2.new(0, 44, 0, 44),
			zIndex = zIndex,
			iconHorizontalAlignment = Enum.HorizontalAlignment.Right,
			iconSpritePath = imagePath,
			iconSpriteFrame = frame,
			onClick = function(_)
				self.props.setSearchAreaActive(true)
			end
		}),
		SearchBox = Roact.createElement(SearchBox, {
			anchorPoint = Vector2.new(0, 0.5),
			position = UDim2.new(0, 0, 0.5, 0),
			size = UDim2.new(1, -v, 0, 28),
			zIndex = zIndex,
			visible = searchAreaActive,
			modalFocused = searchAreaActive,
			onTextChanged = setSearchText,
			onTextBoxFocused = function()
				if GetFFlagShareGameSearchBoxFocusAnalytics() and self.props.analytics then
					self.props.analytics:onSearchFocused()
				end
			end,
			onTextBoxFocusLost = function(p)
				if p == "" then
					self.props.setSearchAreaActive(false)
				end
			end,
			searchFieldRef = function(searchField)
				self.searchField = searchField
			end
		}),
		Cancel = Roact.createElement("TextButton", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.new(0, textWidth, 1, 0),
			TextSize = textSize,
			TextColor3 = GRAY3,
			Font = font,
			ZIndex = zIndex,
			Visible = searchAreaActive,
			[Roact.Ref] = function(instance)
				if instance then
					instance.Text = cancelText

					if not self.textConnection then
						self.textConnection = instance:GetPropertyChangedSignal("Text"):connect(function()
							self:setState({ cancelText = instance.Text })
						end)
					end
				end
			end,
			[Roact.Event.Activated] = function(_)
				self.props.setSearchAreaActive(false)
			end
		})
	})
end

function extended.didUpdate(p, p2)
	local fullWidthSearchBar = p.props.fullWidthSearchBar

	if p.searchField then
		if not p.props.isPageOpen and p2.isPageOpen then
			spawn(function()
				if fullWidthSearchBar then
					p.props.setSearchAreaActive(false)
				else
					p.searchField.Text = ""
				end
			end)
		end

		if fullWidthSearchBar then
			local searchAreaActive = p.props.searchAreaActive
			local searchAreaActive2 = p2.searchAreaActive

			if searchAreaActive and not searchAreaActive2 then
				p.searchField:CaptureFocus()
			elseif not searchAreaActive and searchAreaActive2 then
				p.searchField.Text = ""
			end
		end
	end
end

return (RoactRodux.UNSTABLE_connect2(function(p, _)
	return { isPageOpen = p.Page.IsOpen, searchAreaActive = p.ConversationsSearch.SearchAreaActive }
end, function(callback)
	return {
		setSearchAreaActive = function(p)
			callback(SetSearchAreaActive(p))
		end,
		setSearchText = function(p)
			callback(SetSearchText(p))
		end
	}
end)(extended))
