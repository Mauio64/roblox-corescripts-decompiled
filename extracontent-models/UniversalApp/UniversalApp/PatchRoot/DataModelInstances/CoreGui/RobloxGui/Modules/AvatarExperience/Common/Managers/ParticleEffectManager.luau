local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = CoreGui.RobloxGui.Modules
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Utils2 = require(Modules.AvatarExperience.AvatarEditor.Utils)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local t1 = {}

t1.__index = t1

function t1.new(p1, p2) -- line: 25
	-- upvalues: t1 (copy), ReplicatedStorage (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2.connections = {}
	t2.store = p1
	t2.avatarRoute = p2
	t2.avatarSwapPFX = {}

	for _ = 1, 4 do
		table.insert(t2.avatarSwapPFX, ReplicatedStorage:WaitForChild("AvatarSwap-PFX"):Clone())
	end

	t2.emissionId = 0
	t2.destroyed = false

	return t2
end
function t1.setAvatarRoute(p3, p4) -- line: 46
	p3.avatarRoute = p4
end
function t1.start(p5) -- line: 50
	-- upvalues: Workspace (copy)
	for _, v20 in p5.avatarSwapPFX do
		v20.Parent = Workspace
		v20.MainEmitter.Rate = 10
		v20.MediumEmitter.MediumEmissions.Rate = 20
		v20.SmallerEmitter.SmallerEmissions.Rate = 20
	end

	local v21 = p5.store.changed:connect(function(p6, p7) -- line: 57
		-- upvalues: p5 (copy)
		p5:update(p6, p7)
	end)

	table.insert(p5.connections, v21)
	p5.oldAccessories = {}
	p5.changedAccessories = {}
	p5.curCharacter = nil
	p5.accessoryPositions = {}
end
function t1.stop(p8) -- line: 68
	-- upvalues: ReplicatedStorage (copy)
	for _, v24 in p8.avatarSwapPFX do
		v24.Parent = ReplicatedStorage
	end

	for _, v26 in p8.connections do
		v26:disconnect()
	end

	p8.connections = {}
end

local _next = next

function t1.getAttachmentOrPartPosition(p9, p10) -- line: 79
	-- upvalues: Constants (copy), Utils (copy)
	local AvatarType = p9.store:getState().AvatarExperience.AvatarEditor.Character.AvatarType
	local v30 = Constants.AssetTypeIdToPartsAndAttachments[AvatarType][p10]

	if v30 == nil then
		return nil
	end

	local t3 = {}

	for _, v33 in v30 do
		local v34 = v33 and (v33.Attachment and Utils.getAttachmentCFrame(p9.curCharacter, v33.Part, v33.Attachment) or Utils.getPartCFrame(p9.curCharacter, v33.Part)) or nil

		if v34 ~= nil and v34.Position ~= nil then
			table.insert(t3, v34.Position)
		end
	end

	return t3
end
function t1.getChangedTryOnPart(t4: {[any]: any}, t5: {[any]: any}, t6: {[any]: any}) -- line: 102
	local v38 = t6.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledItem or {}
	local v39 = t5.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledItem or {}

	if v39 == v38 then
		return nil, nil
	end

	return v39.itemId or v38.itemId, t4:getAttachmentOrPartPosition(v39.itemSubType or v38.itemSubType)
end
function t1.getChangedEquippedPart(t7: {[any]: any}, t8: {[any]: any}, t9: {[any]: any}) -- line: 112
	-- upvalues: Utils2 (copy), _next (copy)
	local v43 = t9.AvatarExperience.AvatarEditor.Character.EquippedAssets or {}
	local v44 = t8.AvatarExperience.AvatarEditor.Character.EquippedAssets or {}
	local v45 = Utils2.getEquippedDiffs(v44, v43)
	local v46, v47 = _next(v45)

	if v46 then
		return v47[1], t7:getAttachmentOrPartPosition(v46)
	end

	return nil, nil
end
function t1.setPositions(t10: {[any]: any}, t11: {[any]: any}) -- line: 123
	for v50, v51 in t11 do
		if v50 > 4 then
			return
		end

		t10.avatarSwapPFX[v50].Position = v51
		t10.avatarSwapPFX[v50].MediumEmitter.Position = v51
		t10.avatarSwapPFX[v50].SmallerEmitter.Position = v51
	end
end
function t1.getChangedAttachmentPosition(t12: {[any]: any}, t13: {[any]: any}, t14: {[any]: any}) -- line: 137
	-- upvalues: _next (copy)
	if _next(t12.changedAccessories) then
		local t15 = {}
		local t16 = {}

		for _, v58 in t12.changedAccessories do
			local v59 = t12.accessoryPositions[v58.accessory.Name]

			if v59 then
				table.insert(t15, v59)

				if v58.removed then
					t12.accessoryPositions[v58.accessory.Name] = nil
				end
			elseif not v58.removed then
				table.insert(t16, v58)
			end
		end

		t12.changedAccessories = t16

		return t15
	end

	local _, v61 = t12:getChangedEquippedPart(t13, t14)

	if not v61 then
		local v62

		v62, v61 = t12:getChangedTryOnPart(t13, t14)
	end

	return v61
end
function t1.getAccessories(t17: {[any]: any}, _: {[any]: any}) -- line: 166
	return (t17.curCharacter:FindFirstChildOfClass("Humanoid"):GetAccessories())
end
function t1.cachePosition(p11, p12) -- line: 172
	local BasePart = p12:FindFirstChildWhichIsA("BasePart")

	if BasePart then
		p11.accessoryPositions[p12.Name] = BasePart.Position
	end

	return BasePart
end
function t1.updateChangedAccessory(t19: {[any]: any}, t20: {[any]: any}) -- line: 180
	-- upvalues: Utils2 (copy), Cryo (copy)
	local v70 = t19:getAccessories(t20)
	local v71 = Utils2.diffList(v70, t19.oldAccessories)
	local oldAccessories = t19.oldAccessories
	local v73 = Cryo.List.map(v71, function(p13) -- line: 184
		-- upvalues: Cryo (copy), oldAccessories (copy)
		if Cryo.List.find(oldAccessories, p13) then
			return {
				removed = true,
				accessory = p13
			}
		end

		return {
			removed = false,
			accessory = p13
		}
	end)

	t19.changedAccessories = Cryo.List.join(t19.changedAccessories, v73)

	for _, v75 in t19.changedAccessories do
		if not t19.accessoryPositions[v75.accessory.Name] then
			t19:cachePosition(v75.accessory)
		end
	end

	t19.oldAccessories = v70
end
function t1.update(t21: {[any]: any}, t22: {[any]: any}, t23: {[any]: any}) -- line: 201
	-- upvalues: _next (copy)
	if not t22.AvatarExperience.AvatarScene.Character.CurrentCharacter then
		return
	end

	t21.curCharacter = t22.AvatarExperience.AvatarScene.Character.CurrentCharacter
	t21:updateChangedAccessory(t22)

	local v79 = t22.AvatarExperience.AvatarEditor.Character.EquippedAssets ~= t23.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local v80 = t22.AvatarExperience.AvatarEditor.Character.AvatarType ~= t23.AvatarExperience.AvatarEditor.Character.AvatarType
	local v81 = t22.AvatarExperience.AvatarEditor.Character.BodyColors ~= t23.AvatarExperience.AvatarEditor.Character.BodyColors
	local v82 = t22.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems ~= t23.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local name = t21.avatarRoute.opaque.name

	if name == "ProfilePictureEditorEmotes" or name == "ProfilePictureEditorCamera" or name == "ProfilePictureEditorFinal" then
		for i = 1, #t21.avatarSwapPFX do
			t21.avatarSwapPFX[i].MainEmitter.Enabled = false
			t21.avatarSwapPFX[i].MediumEmitter.MediumEmissions.Enabled = false
			t21.avatarSwapPFX[i].SmallerEmitter.SmallerEmissions.Enabled = false
		end

		return
	end

	if v79 or v80 or v81 or v82 or _next(t21.changedAccessories) then
		local v85 = t21:getChangedAttachmentPosition(t22, t23)

		if v85 and _next(v85) then
			t21:setPositions(v85)
			t21:runParticleEmitter(#v85)
		end
	end
end
function t1.runParticleEmitter(t24: {[any]: any}, n1: number) -- line: 249
	task.spawn(function() -- line: 250
		-- upvalues: n1 (copy), t24 (copy)
		local v92 = math.min(n1, 4)

		for v93, v94 in t24.avatarSwapPFX do
			if v92 < v93 then
				v94.MainEmitter.Enabled = false
				v94.MediumEmitter.MediumEmissions.Enabled = false
				v94.SmallerEmitter.SmallerEmissions.Enabled = false
			else
				v94.MainEmitter.Enabled = true
				v94.MediumEmitter.MediumEmissions.Enabled = true
				v94.SmallerEmitter.SmallerEmissions.Enabled = true
			end
		end

		t24.emissionId = t24.emissionId + 1

		local emissionId = t24.emissionId

		task.wait(0.3)

		if t24.destroyed then
			return
		end

		if emissionId == t24.emissionId then
			for i = 1, v92 do
				t24.avatarSwapPFX[i].MainEmitter.Enabled = false
				t24.avatarSwapPFX[i].MediumEmitter.MediumEmissions.Enabled = false
				t24.avatarSwapPFX[i].SmallerEmitter.SmallerEmissions.Enabled = false
			end
		end
	end)
end
function t1.onDestroy(p14) -- line: 283
	p14.avatarSwapPFX[1]:Destroy()
	p14.avatarSwapPFX[2]:Destroy()
	p14.avatarSwapPFX[3]:Destroy()
	p14.avatarSwapPFX[4]:Destroy()
	p14.destroyed = true
end

return t1
