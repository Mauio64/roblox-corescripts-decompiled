local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle

local function renderWrappingCenter(p1) -- line: 30
	-- upvalues: withStyle (copy), React (copy)
	return function() -- line: 31
		-- upvalues: withStyle (copy), React (copy), p1 (copy)
		return withStyle(function(p2) -- line: 32
			-- upvalues: React (copy), p1 (copy)
			local Theme = p2.Theme
			local p2Font = p2.Font

			return React.createElement("TextLabel", {
				TextSize = 20,
				TextWrapped = true,
				BackgroundTransparency = 1,
				Text = p1,
				Font = p2Font.Header2.Font,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(1, 0, 1, 0)
			})
		end)
	end
end
local function renderHeaderBarLeft(p3, p4, p5, p6, p7) -- line: 52
	-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy)
	local v22 = p6 or p7

	return function() -- line: 54
		-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy), p3 (copy), v22 (copy), p7 (copy), p4 (copy), p6 (copy), p5 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 120, 1, 0)
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
				onActivated = p3
			}),
			UndoButton = v22 and React.createElement(IconButton, {
				layoutOrder = 2,
				iconSize = IconSize.Medium,
				icon = Images["icons/actions/edit/undo"],
				isDisabled = not p7,
				onActivated = p4
			}),
			RedoButton = v22 and React.createElement(IconButton, {
				layoutOrder = 3,
				iconSize = IconSize.Medium,
				icon = Images["icons/actions/edit/redo"],
				isDisabled = not p6,
				onActivated = p5
			})
		})
	end
end
local function renderHeaderBarRight(p8, p9) -- line: 89
	-- upvalues: React (copy), ButtonStack (copy), ButtonType (copy), RobloxTranslator (copy)
	return function() -- line: 90
		-- upvalues: React (copy), ButtonStack (copy), ButtonType (copy), p8 (copy), p9 (copy), RobloxTranslator (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 144, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Buttons = React.createElement(ButtonStack, {
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = function() -- line: 105
							-- upvalues: p8 (copy), p9 (copy)
							p8(p9)
						end,
						text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.Next")
					}
				}}
			})
		})
	end
end
local function LandscapeModeHeader(t1: {[any]: any}) -- line: 116
	-- upvalues: React (copy), HeaderBar (copy), IconButton (copy), IconSize (copy), Images (copy), ButtonStack (copy), ButtonType (copy), RobloxTranslator (copy), withStyle (copy)
	local createElement = React.createElement
	local t2 = {
		BackgroundTransparency = 0,
		LayoutOrder = 1,
		ZIndex = 2,
		BackgroundColor3 = Color3.fromHex("#4F545F"),
		Size = UDim2.new(1, 0, 0, 47)
	}
	local t3 = {}
	local createElement2 = React.createElement
	local v30 = HeaderBar
	local t4 = {
		backgroundTransparency = 1,
		barHeight = 48
	}
	local backAction = t1.backAction
	local undoAnnotationPoints = t1.undoAnnotationPoints
	local redoAnnotationPoints = t1.redoAnnotationPoints
	local isRedoEnabled = t1.isRedoEnabled
	local isUndoEnabled = t1.isUndoEnabled
	local v37 = isRedoEnabled or isUndoEnabled

	function t4.renderLeft() -- line: 54
		-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy), backAction (copy), v37 (copy), isUndoEnabled (copy), undoAnnotationPoints (copy), isRedoEnabled (copy), redoAnnotationPoints (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 120, 1, 0)
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
			}),
			UndoButton = v37 and React.createElement(IconButton, {
				layoutOrder = 2,
				iconSize = IconSize.Medium,
				icon = Images["icons/actions/edit/undo"],
				isDisabled = not isUndoEnabled,
				onActivated = undoAnnotationPoints
			}),
			RedoButton = v37 and React.createElement(IconButton, {
				layoutOrder = 3,
				iconSize = IconSize.Medium,
				icon = Images["icons/actions/edit/redo"],
				isDisabled = not isRedoEnabled,
				onActivated = redoAnnotationPoints
			})
		})
	end

	local finishAnnotationAction = t1.finishAnnotationAction
	local annotationPoints = t1.annotationPoints

	function t4.renderRight() -- line: 90
		-- upvalues: React (copy), ButtonStack (copy), ButtonType (copy), finishAnnotationAction (copy), annotationPoints (copy), RobloxTranslator (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 144, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Buttons = React.createElement(ButtonStack, {
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = function() -- line: 105
							-- upvalues: finishAnnotationAction (copy), annotationPoints (copy)
							finishAnnotationAction(annotationPoints)
						end,
						text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.Next")
					}
				}}
			})
		})
	end

	local titleText = t1.titleText

	function t4.renderCenter() -- line: 31
		-- upvalues: withStyle (copy), React (copy), titleText (copy)
		return withStyle(function(p10) -- line: 32
			-- upvalues: React (copy), titleText (copy)
			local Theme = p10.Theme
			local p10Font = p10.Font

			return React.createElement("TextLabel", {
				TextSize = 20,
				TextWrapped = true,
				BackgroundTransparency = 1,
				Text = titleText,
				Font = p10Font.Header2.Font,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(1, 0, 1, 0)
			})
		end)
	end

	t3.Bar = createElement2(v30, t4)

	return createElement("Frame", t2, t3)
end

return LandscapeModeHeader
