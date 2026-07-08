local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local UIBlox = InGameMenuDependencies.UIBlox
local withStyle = UIBlox.Core.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ParentParent = script.Parent.Parent
local NavigateUp = require(ParentParent.Thunks.NavigateUp)
local Assets = require(ParentParent.Resources.Assets)
local Constants = require(ParentParent.Resources.Constants)
local ZonePortal = require(ParentParent.Components.ZonePortal)
local Direction = require(ParentParent.Enums.Direction)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local ThemedTextLabel = require(script.Parent.ThemedTextLabel)

local function renderWithSelectionCursor(p1, p2) -- line: 28
	-- upvalues: withStyle (copy), Roact (copy), ImageSetButton (copy), Assets (copy), CursorKind (copy), ThemedTextLabel (copy), Constants (copy), ZonePortal (copy), Direction (copy)
	return withStyle(function(p3) -- line: 29
		-- upvalues: p1 (copy), Roact (copy), ImageSetButton (copy), Assets (copy), p2 (copy), CursorKind (copy), ThemedTextLabel (copy), Constants (copy), ZonePortal (copy), Direction (copy)
		local t1 = {
			ExtraChildren = p1.titleChildren,
			BackButton = Roact.createElement(ImageSetButton, {
				BackgroundTransparency = 1,
				Image = Assets.Images.NavigateBack,
				AnchorPoint = Vector2.new(0, 0.5),
				ImageColor3 = p3.Theme.IconEmphasis.Color,
				ImageTransparency = p3.Theme.IconEmphasis.Transparency,
				Position = UDim2.new(0, 4, 0.5, 0),
				Size = UDim2.new(0, 36, 0, 36),
				NextSelectionDown = p1.NextSelectionDown,
				[Roact.Event.Activated] = p1.navigateUp,
				[Roact.Ref] = p1.buttonRef,
				SelectionImageObject = p2(CursorKind.RoundedRect)
			})
		}

		return Roact.createElement("TextButton", {
			AutoButtonColor = false,
			Text = "",
			BorderSizePixel = 0,
			Selectable = false,
			BackgroundColor3 = p3.Theme.BackgroundContrast.Color,
			BackgroundTransparency = p3.Theme.BackgroundContrast.Transparency,
			Position = p1.position,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = p1.visible and not p1.pageIsModal,
			ZIndex = p1.zIndex
		}, {
			PageTitle = Roact.createElement(ThemedTextLabel, {
				fontKey = "Header1",
				themeKey = "TextEmphasis",
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 28),
				Size = UDim2.new(1, -48, 0, 28),
				Text = p1.pageTitle
			}, t1),
			PageContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, Constants.Zone.ContentOffset, 1, 0),
				Size = UDim2.new(1, -Constants.Zone.ContentOffset, 1, -68)
			}, p1[Roact.Children]),
			ZonePortal = Roact.createElement(ZonePortal, {
				targetZone = 0,
				direction = Direction.Left
			})
		})
	end)
end
local function Page(p4) -- line: 82
	-- upvalues: withSelectionCursorProvider (copy), renderWithSelectionCursor (copy)
	return withSelectionCursorProvider(function(p5) -- line: 83
		-- upvalues: renderWithSelectionCursor (copy), p4 (copy)
		return renderWithSelectionCursor(p4, p5)
	end)
end

return RoactRodux.UNSTABLE_connect2(nil, function(p6) -- line: 88
	-- upvalues: NavigateUp (copy)
	return {
		navigateUp = function() -- line: 90
			-- upvalues: p6 (copy), NavigateUp (copy)
			p6(NavigateUp)
		end
	}
end)(Page)
