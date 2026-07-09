local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

require(CorePackages.Packages.UIBlox).init({})

local GraphQL = require(CorePackages.Workspace.Packages.GraphQL)

local function recursiveToString(p1, s1: string) -- line: 12
	-- upvalues: recursiveToString (copy)
	if type(p1) == "function" then
		error("Can't convert function to string")

		return
	end

	if type(p1) == "table" then
		local v12 = "" .. "{"
		local n1 = 0

		for _, _ in pairs(p1) do
			n1 += 1
		end

		if n1 > 1 then
			v12 ..= "\n"
		end

		for k, v in pairs(p1) do
			if type(k) == "string" then
				v12 ..= "  " .. s1 .. tostring(k) .. " = " .. recursiveToString(v, "  " .. s1) .. ",\n"
			end

			if type(k) == "number" then
				v12 ..= "  " .. s1 .. recursiveToString(v, "  " .. s1) .. ",\n"
			end
		end

		if n1 > 0 then
			return v12 .. s1 .. "}"
		end

		return v12 .. "}"
	end

	if type(p1) == "string" then
		return "\"" .. tostring(p1) .. "\""
	end

	return (tostring(p1))
end

if game:GetService("ProcessService"):GetCommandLineArgs()[1] == "individual" then
	local data = HttpService:JSONDecode(require(CorePackages.Workspace.Packages.GraphQLCompile).gqlCompileData())

	for _, v7 in data do
		v7.compiled = recursiveToString(GraphQL.parse(v7.content, {
			noLocation = true
		}), "")
	end

	local json = HttpService:JSONEncode(data)

	print(json)
else
	local GraphQLServer = require(CorePackages.Workspace.Packages.GraphQLServer)

	print(recursiveToString(GraphQL.parse(GraphQLServer.generateTypeDefs(), {
		noLocation = true
	}), ""))
end

return {}
