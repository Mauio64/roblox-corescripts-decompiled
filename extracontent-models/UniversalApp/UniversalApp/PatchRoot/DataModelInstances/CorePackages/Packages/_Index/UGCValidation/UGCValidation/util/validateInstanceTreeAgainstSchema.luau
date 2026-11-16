local parent = script.Parent.Parent

require(parent.util.Types)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local function checkName(name, name2: string): boolean -- 2 equivalent calls inferred from this helper
	if type(name) == "table" then
		return table.find(name, name2) ~= nil
	end

	return name == name2
end

local function getReadableName(name) -- 2 equivalent calls inferred from this helper
	if type(name) == "table" then
		return table.concat(name, " or ")
	end

	return if type(name) == "string" then name else "*"
end

local function validateInstancesFromSchema(folder, instance, p, object, missingErrorKey: string?, skipInstanceContext: boolean?)
	p[folder] = true

	if instance._ignoreDescendants then
		assert(
			not instance._children,
			"if _ignoreDescendants is true, there should be no descendants in the schema as they would be ignored anyway"
		)

		for _, descendant in folder:GetDescendants() do
			p[descendant] = true
		end
	else
		for _, v in instance._children or {} do
			local v2 = false

			for _, child in folder:GetChildren() do
				if p[child] == nil and child.ClassName == v.ClassName then
					if v.Name ~= nil and not checkName(v.Name, child.Name) then -- inferred equivalent call
						continue
					end

					validateInstancesFromSchema(child, v, p, object, missingErrorKey, skipInstanceContext)
					v2 = true
					break
				end
			end

			if v2 or v._optional then
				continue
			end

			local v3 = missingErrorKey or ErrorSourceStrings.Keys.AssetSchemaMissingItem
			local v4

			if not skipInstanceContext then
				v4 = folder
			end

			local v5 = {
				ParentPath = folder:GetFullName(),
				ExpectedClass = v.ClassName,
				ExpectedName = getReadableName(v.Name), -- inferred equivalent call
				detail = 0
			}
			local formatted = `missing required {v.ClassName}`
			local v6

			if v.Name then
				local readableName = getReadableName(v.Name) -- inferred equivalent call
				v6 = ` named '{readableName}'`
			else
				v6 = ""
			end

			v5.detail = formatted .. v6 .. ` inside '{folder.Name}'`
			object:fail(v3, v5, v4)
		end
	end
end

local function validateNoInstancesOutsideSchema(folder, p, object, unauthorizedErrorKey: string?, skipInstanceContext: boolean?)
	local fullNames = {}

	for _, descendant in folder:GetDescendants() do
		if p[descendant] == nil then
			table.insert(fullNames, descendant:GetFullName())
		end
	end

	if #fullNames > 0 then
		local v = unauthorizedErrorKey or ErrorSourceStrings.Keys.AssetSchemaUnexpectedItems

		if skipInstanceContext then
			folder = nil
		end

		object:fail(
			v,
			{
				UnexpectedDescendantPaths = table.concat(fullNames, ", "),
				detail = `unauthorized instances found: {table.concat(fullNames, ", ")}`
			},
			folder
		)
	end
end

local function validateInstanceTreeAgainstSchema(instance, instance2, object, data)
	local skipRootClassCheck

	if data then
		skipRootClassCheck = data.skipRootClassCheck
	end

	local missingErrorKey

	if data then
		missingErrorKey = data.missingErrorKey
	end

	local unauthorizedErrorKey

	if data then
		unauthorizedErrorKey = data.unauthorizedErrorKey
	end

	local skipInstanceContext

	if data then
		skipInstanceContext = data.skipInstanceContext
	end

	local v = {}

	if not skipRootClassCheck then
		if instance2.ClassName ~= instance.ClassName then
			object:fail(ErrorSourceStrings.Keys.AssetSchemaWrongRootClass, {
				RootClass = instance.ClassName,
				ExpectedClass = instance2.ClassName
			})

			return
		end

		if instance2.Name ~= nil and not checkName(instance2.Name, instance.Name) then -- inferred equivalent call
			object:fail(ErrorSourceStrings.Keys.AssetSchemaWrongRootName, {
				RootName = instance.Name,
				ExpectedName = instance2.Name
			})

			return
		end
	end

	validateInstancesFromSchema(instance, instance2, v, object, missingErrorKey, skipInstanceContext)
	validateNoInstancesOutsideSchema(instance, v, object, unauthorizedErrorKey, skipInstanceContext)
end

return validateInstanceTreeAgainstSchema
