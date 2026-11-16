local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
require(ViewRecyclerRoblox.Parent.ViewRecycler)

local ScrollbarOverlay = require(ViewRecyclerRoblox.RobloxAdapter.ScrollbarOverlay)

local function createFrame(name: string, parent) -- 3 equivalent calls inferred from this helper
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Active = false
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Selectable = false
	frame.Parent = parent
	return frame
end

return {
	new = function(instance, p)
		local viewRecyclerOverlayContainer = Instance.new("Folder")
		viewRecyclerOverlayContainer.Name = "ViewRecyclerOverlayContainer"
		local frame = createFrame("ViewRecyclerOverlayBounds", viewRecyclerOverlayContainer) -- inferred equivalent call
		frame.Size = UDim2.fromScale(1, 1)
		local frame2 = createFrame("ViewRecyclerOverlayWindow", frame) -- inferred equivalent call
		local frame3 = createFrame("ViewRecyclerOverlay", frame2) -- inferred equivalent call
		frame3.ClipsDescendants = true
		local v = ScrollbarOverlay.connect(instance, frame3, p)
		local flag = false

		local function synchronize()
			if flag or viewRecyclerOverlayContainer.Parent == nil then
				return
			end

			frame2.Visible = instance.Visible
			frame2.ZIndex = instance.ZIndex + 1
			frame.ZIndex = frame2.ZIndex
			local absoluteSize = frame.AbsoluteSize

			if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
				return
			end

			local absoluteSize2 = instance.AbsoluteSize
			local v2 = instance.AbsolutePosition - frame.AbsolutePosition
			frame2.Size = UDim2.fromScale(absoluteSize2.X / absoluteSize.X, absoluteSize2.Y / absoluteSize.Y)
			local v3 = instance.AbsolutePosition - frame2.AbsolutePosition

			if math.abs(v3.X) >= 0.5 or math.abs(v3.Y) >= 0.5 then
				frame2.Position = UDim2.fromScale(v2.X / absoluteSize.X, v2.Y / absoluteSize.Y)
			end
		end

		local function reparent() -- 1 equivalent call inferred from this helper
			if flag then
				return
			end

			viewRecyclerOverlayContainer.Parent = instance.Parent
			synchronize()
		end

		local v2 = {
			instance:GetPropertyChangedSignal("AbsolutePosition"):Connect(synchronize),
			instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(synchronize),
			instance:GetPropertyChangedSignal("Visible"):Connect(synchronize),
			instance:GetPropertyChangedSignal("ZIndex"):Connect(synchronize),
			instance:GetPropertyChangedSignal("Parent"):Connect(reparent),
			frame2:GetPropertyChangedSignal("AbsolutePosition"):Connect(synchronize),
			frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(synchronize)
		}
		reparent() -- inferred equivalent call
		return table.freeze({
			overlay = frame3,
			destroy = function()
				if flag then
					return
				end

				flag = true

				for _, connection in v2 do
					connection:Disconnect()
				end

				v()
				viewRecyclerOverlayContainer:Destroy()
			end
		})
	end
}
