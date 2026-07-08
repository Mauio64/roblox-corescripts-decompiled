local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle

local function renderHeaderBarLeft(p1, _, _) -- line: 25
	-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy)
	return function() -- line: 26
		-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy), p1 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 30, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			BackButton = React.createElement(IconButton, {
				layoutOrder = 1,
				iconSize = IconSize.Medium,
				icon = Images["icons/navigation/pushBack"],
				onActivated = p1
			})
		})
	end
end
local function renderCenter(p4) -- line: 47
	-- upvalues: withStyle (copy), React (copy)
	return function() -- line: 48
		-- upvalues: withStyle (copy), React (copy), p4 (copy)
		return withStyle(function(p5) -- line: 49
			-- upvalues: React (copy), p4 (copy)
			local CurrentCamera = game.Workspace.CurrentCamera
			local n1 = 300

			if CurrentCamera ~= nil then
				n1 = CurrentCamera.ViewportSize.X - 150
			end

			local Theme = p5.Theme
			local p5Font = p5.Font

			return React.createElement("TextLabel", {
				TextSize = 20,
				TextWrapped = true,
				BackgroundTransparency = 1,
				Text = p4,
				Font = p5Font.Header2.Font,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(0, n1, 1, 0)
			})
		end)
	end
end
local function renderHeaderBarRight(_, p7, p8, p9, p10) -- line: 76
	-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy)
	return function() -- line: 83
		-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy), p9 (copy), p7 (copy), p10 (copy), p8 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 60, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			UndoButton = React.createElement(IconButton, {
				layoutOrder = 1,
				iconSize = IconSize.Medium,
				icon = Images["icons/actions/edit/undo"],
				isDisabled = not p9,
				onActivated = p7
			}),
			RedoButton = React.createElement(IconButton, {
				layoutOrder = 2,
				iconSize = IconSize.Medium,
				icon = Images["icons/actions/edit/redo"],
				isDisabled = not p10,
				onActivated = p8
			})
		})
	end
end
local function ScreenshotDialogPortraitModeHeader(t1: {[any]: any}) -- line: 111
	-- upvalues: React (copy), HeaderBar (copy), IconButton (copy), IconSize (copy), Images (copy), withStyle (copy)
	local v23 = t1.isRedoEnabled or t1.isUndoEnabled
	local createElement = React.createElement
	local t2 = {
		BackgroundTransparency = 0,
		LayoutOrder = 1,
		ZIndex = 2,
		BackgroundColor3 = Color3.fromHex("#4F545F"),
		Size = UDim2.new(1, 0, 0, 48)
	}
	local t3 = {}
	local createElement2 = React.createElement
	local v28 = HeaderBar
	local t4 = {
		backgroundTransparency = 1,
		barHeight = 48,
		margin = 12,
		isSecondary = true
	}
	local backAction = t1.backAction
	local _ = t1.isRedoEnabled
	local _ = t1.isUndoEnabled

	function t4.renderLeft() -- line: 26
		-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy), backAction (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 30, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			BackButton = React.createElement(IconButton, {
				layoutOrder = 1,
				iconSize = IconSize.Medium,
				icon = Images["icons/navigation/pushBack"],
				onActivated = backAction
			})
		})
	end

	local v38

	if v23 then
		local _ = t1.annotationPoints
		local undoAnnotationPoints = t1.undoAnnotationPoints
		local redoAnnotationPoints = t1.redoAnnotationPoints
		local isUndoEnabled = t1.isUndoEnabled
		local isRedoEnabled = t1.isRedoEnabled

		function v38() -- line: 83
			-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy), isUndoEnabled (copy), undoAnnotationPoints (copy), isRedoEnabled (copy), redoAnnotationPoints (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 60, 1, 0)
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				UndoButton = React.createElement(IconButton, {
					layoutOrder = 1,
					iconSize = IconSize.Medium,
					icon = Images["icons/actions/edit/undo"],
					isDisabled = not isUndoEnabled,
					onActivated = undoAnnotationPoints
				}),
				RedoButton = React.createElement(IconButton, {
					layoutOrder = 2,
					iconSize = IconSize.Medium,
					icon = Images["icons/actions/edit/redo"],
					isDisabled = not isRedoEnabled,
					onActivated = redoAnnotationPoints
				})
			})
		end
	else
		function v38() -- line: 134
		end
	end

	t4.renderRight = v38

	local titleText = t1.titleText

	function t4.renderCenter() -- line: 48
		-- upvalues: withStyle (copy), React (copy), titleText (copy)
		return withStyle(function(p11) -- line: 49
			-- upvalues: React (copy), titleText (copy)
			local CurrentCamera = game.Workspace.CurrentCamera
			local n2 = 300

			if CurrentCamera ~= nil then
				n2 = CurrentCamera.ViewportSize.X - 150
			end

			local Theme = p11.Theme
			local p11Font = p11.Font

			return React.createElement("TextLabel", {
				TextSize = 20,
				TextWrapped = true,
				BackgroundTransparency = 1,
				Text = titleText,
				Font = p11Font.Header2.Font,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(0, n2, 1, 0)
			})
		end)
	end

	t3.Bar = createElement2(v28, t4)

	return createElement("Frame", t2, t3)
end

return ScreenshotDialogPortraitModeHeader
