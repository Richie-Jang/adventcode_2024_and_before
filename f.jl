function delete_exe(cur)
	files = readdir(cur)
	for i in files
		p = joinpath(cur, i)
		if isfile(p) && endswith(i, "exe")
			rm(p)
		end
	end	
end

cur = pwd()
folders = ["2015", "2016", "2020", "2023", "2024"]
folder1s = [joinpath(cur, i) for i in folders]

folder2s = begin
	res = []
	for i in folder1s
		rs = readdir(i)		
		push!(res, [joinpath(i, x) for x in rs]...)
	end
	res
end

for i in folder2s
	delete_exe(i)
end