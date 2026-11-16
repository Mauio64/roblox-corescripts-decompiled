local function checkName(name, name2): boolean -- 2 equivalent calls inferred from this helper
	if type(name) == "table" then
		for _, item in pairs(name) do
			if item == name2 then
				return true
			end
		end
	elseif type(name) == "string" then
		return name == name2
	end

	return false
end

local function getReadableName(name) -- 3 equivalent calls inferred from this helper
	if type(name) == "table" then
		return table.concat(name, " or ")
	end

	return if type(name) == "string" then name else "*"
end

local function validateWithSchemaHelper(instance, folder, p)
	if folder.ClassName ~= instance.ClassName or instance.Name ~= nil and not checkName(instance.Name, folder.Name) then -- inferred equivalent call
		return { success = false }
	end

	if instance._ignoreDescendants then
		assert(
			not instance._children,
			"if _ignoreDescendants is true, there should be no descendants in the schema as they would be ignored anyway"
		)

		for _, descendant in folder:GetDescendants() do
			p[descendant] = true
		end
	elseif instance._children then
		for _, v in pairs(instance._children) do
			local v2 = nil
			local v3 = false

			for _, child in pairs(folder:GetChildren()) do
				if p[child] then
					continue
				end

				local v4 = validateWithSchemaHelper(v, child, p)

				if v4.success then
					v3 = true
					break
				elseif v4.message then
					v2 = v4
				end
			end

			if not (v3 or v._optional) then
				if v2 then
					return v2
				end

				return {
					success = false,
					message = "Could not find a " .. v.ClassName .. " called " .. getReadableName(v.Name) .. " inside " .. folder.Name -- inferred equivalent call
				}
			end
		end
	end

	p[folder] = true
	return { success = true }
end

local function validateWithSchema(instance, folder, _)
	local v, v2, className, v3, name, v4

	if folder.ClassName == instance.ClassName then
		if instance.Name ~= nil and not checkName(instance.Name, folder.Name) then -- inferred equivalent call
			v = { success = false, message = 0 }

			v2 = "Expected top-level instance to be a "
			className = instance.ClassName
			v3 = " named "
			name = instance.Name
			v4 = getReadableName(name) -- inferred equivalent call
			v.message = v2 .. className .. v3 .. v4
			return v
		end

		local v5 = {}

		if not validateWithSchemaHelper(instance, folder, v5).success then
			return { success = false, message = "" }
		end

		local fullNames = {}

		for _, descendant in pairs(folder:GetDescendants()) do
			if v5[descendant] == nil then
				fullNames[#fullNames + 1] = descendant:GetFullName()
			end
		end

		if #fullNames > 0 then
			return { success = false, message = "" }
		end

		return { success = true }
	end

	v = { success = false, message = 0 }

	v2 = "Expected top-level instance to be a "
	className = instance.ClassName
	v3 = " named "
	name = instance.Name
	v4 = getReadableName(name) -- inferred equivalent call
	v.message = v2 .. className .. v3 .. v4
	return v
end

return validateWithSchema
