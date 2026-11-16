local parent = script.Parent.Parent

require(parent.util.Types)
local getEditableMeshFromContext = require(parent.util.getEditableMeshFromContext)
local getMeshSize = require(parent.util.getMeshSize)
local pcallDeferred = require(parent.util.pcallDeferred)

return function(instance, state, flag: boolean?)
	if state.bypassFlags and state.bypassFlags.skipPhysicsDataReset then
		if not state.partSizes then
			state.partSizes = {}
		end

		if state.partSizes[instance] then
			return state.partSizes[instance]
		end

		local v = {
			fullName = instance:GetFullName(),
			fieldName = "MeshId",
			contentId = instance.MeshId,
			context = instance.Name
		}

		local editableMeshFromContext, editableMesh = getEditableMeshFromContext(instance, "MeshId", state)

		if editableMeshFromContext then
			v.editableMesh = editableMesh

			if state.editableMeshes[instance].MeshId.created then
				return if flag then instance.MeshSize else instance.Size
			else
				local v2, v3 = pcallDeferred(function()
					return getMeshSize(v)
				end, state)

				if v2 then
					state.partSizes[instance] = v3
					return v3
				end

				return if flag then instance.MeshSize else instance.Size
			end
		end
	end

	return if flag then instance.MeshSize else instance.Size
end
