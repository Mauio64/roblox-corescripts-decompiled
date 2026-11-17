local Flags = require(script:FindFirstAncestor("ViewRecyclerRoblox").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")

local SlotGeometry = require(ViewRecyclerRoblox.RobloxAdapter.SlotGeometry)
local GuiService = game:GetService("GuiService")

local ReparentableHost = {}

function ReparentableHost.clearSelection(ancestor)
	local selectedObject = GuiService.SelectedObject

	if selectedObject ~= nil and (selectedObject == ancestor or selectedObject:IsDescendantOf(ancestor)) then
		GuiService.SelectedObject = nil
	end
end

function ReparentableHost.create(name: string)
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Position = UDim2.new()
	frame.Size = UDim2.new()
	return frame
end

function ReparentableHost.place(p, p2)
	p.AutomaticSize = p2.automaticSize

	if FFlagViewRecyclerReact084 then
		p.Position = UDim2.new()
	end

	p.Size = SlotGeometry.getHostSize(p2.automaticSize)
	p.Parent = p2.placeholder
end

function ReparentableHost:detach()
	ReparentableHost.clearSelection(self)
	self.Parent = nil
end

function ReparentableHost.destroy(instance)
	ReparentableHost.detach(instance)
	instance:Destroy()
end

return ReparentableHost
