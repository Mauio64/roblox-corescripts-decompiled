local ParentParent = script.Parent.Parent.Parent.Parent
local Roact = require(ParentParent.Roact)
local RoactGamepad = require(ParentParent.RoactGamepad)
local Cryo = require(ParentParent.Cryo)
local CursorKind = require(script.Parent.CursorKind)
local SelectionImageContext = require(script.Parent.SelectionImageContext)
local OnRootedListener = require(script.Parent.OnRootedListener)
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local v10 = Roact.PureComponent:extend("SelectionCursorProvider")

function v10.init(p1) -- line: 16
	-- upvalues: Roact (copy), RoactGamepad (copy), CursorKind (copy), Cryo (copy), CoreGui (copy), GuiService (copy)
	p1.ref = Roact.createRef()
	p1.refs = RoactGamepad.createRefCache()
	p1.state = {
		currentSelection = nil,
		currentCoreSelection = nil,
		mountedCursors = {}
	}

	function p1.getSelectionCursor(p2) -- line: 25
		-- upvalues: CursorKind (copy), p1 (copy), Cryo (copy)
		assert(CursorKind.isEnumValue(p2), ("Invalid arg #1: expected a CursorKind enum variant, got %s"):format((tostring(p2))))
		warn("UIBlox's SelectionCursor is deprecated and should not be used anymore.")

		if p1.state.mountedCursors[p2] == nil then
			p1:setState(function(p3) -- line: 33
				-- upvalues: Cryo (copy), p2 (copy)
				return {
					mountedCursors = Cryo.Dictionary.join(p3.mountedCursors, {
						[p2] = true
					})
				}
			end)
		end

		return p1.refs[p2]
	end
	function p1.initSelectionChangedListener(p4) -- line: 49
		-- upvalues: p1 (copy), CoreGui (copy), GuiService (copy)
		if p4 == nil then
			return
		end

		if p1.coreSelectionListener ~= nil then
			p1.coreSelectionListener:Disconnect()
			p1.coreSelectionListener = nil
		end

		if p1.selectionListener ~= nil then
			p1.selectionListener:Disconnect()
			p1.selectionListener = nil
		end

		if p4:IsDescendantOf(CoreGui) then
			p1.coreSelectionListener = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 66
				-- upvalues: p1 (copy), GuiService (copy)
				if p1.state.currentCoreSelection == nil or (GuiService.SelectedCoreObject == nil or p1.state.currentCoreSelection.SelectionImageObject ~= GuiService.SelectedCoreObject.SelectionImageObject) then
					p1:setState({
						currentCoreSelection = GuiService.SelectedCoreObject
					})
				end
			end)

			return
		end

		p1.selectionListener = GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- line: 79
			-- upvalues: p1 (copy), GuiService (copy)
			if p1.state.currentSelection == nil or (GuiService.SelectedObject == nil or p1.state.currentSelection.SelectionImageObject ~= GuiService.SelectedObject.SelectionImageObject) then
				p1:setState({
					currentSelection = GuiService.SelectedObject
				})
			end
		end)
	end
end
function v10.didMount(p5) -- line: 93
	p5.initSelectionChangedListener(p5.ref:getValue())
end
function v10.willUnmount(p6) -- line: 97
	if p6.coreSelectionListener ~= nil then
		p6.coreSelectionListener:Disconnect()
		p6.coreSelectionListener = nil
	end

	if p6.selectionListener ~= nil then
		p6.selectionListener:Disconnect()
		p6.selectionListener = nil
	end
end
function v10.render(p7) -- line: 109
	-- upvalues: Roact (copy), SelectionImageContext (copy), OnRootedListener (copy)
	local t1 = {}

	for k, _ in pairs(p7.state.mountedCursors) do
		local v18 = k.rawValue()
		local str = tostring(v18)
		local v20 = p7.refs[k] ~= nil and (p7.state.currentSelection ~= nil and p7.refs[k].current == p7.state.currentSelection.SelectionImageObject or (p7.state.currentCoreSelection == nil or p7.refs[k].current == p7.state.currentCoreSelection.SelectionImageObject))

		t1[str] = Roact.createElement(v18, {
			isVisible = v20,
			cursorRef = p7.refs[k]
		})
	end

	return Roact.createElement(SelectionImageContext.Provider, {
		value = p7.getSelectionCursor
	}, {
		CursorContainer = Roact.createElement("Frame", {
			Visible = false,
			Size = UDim2.new(0, 0, 0, 0)
		}, t1),
		OnRootedListener = Roact.createElement(OnRootedListener, {
			onRooted = p7.initSelectionChangedListener
		}),
		Children = Roact.createFragment(p7.props[Roact.Children])
	})
end

return v10
