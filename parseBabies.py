with open("babies.txt") as babes: babes = babes.read().split("\n")
	
namesB = []
namesG = []

for year in babes[:-1]: # Last line is blank
	babsB1 = []
	babsB2 = []
	babsG1 = []
	babsG2 = []
	yr = year.split("Baby Names - ")[1].split(" ")[0]
	dices = year.split("No.")[4][1:] # Strip header data
	
	while len(babsG2) != 98: # Avoid trailer data/overflow
		nums1 = False
		name1 = ""
		inner = False
		num1 = ""
		nums2 = False
		name2 = ""
		num2 = ""
		for i, char in enumerate(dices): # Go char by char accross the year's data
			if nums1 == False and char.isnumeric(): # If we've reached the first name
				nums1 = True
				name1 = dices[:i]
			elif nums1 and char.isalpha() and nums2 == False and num1 == "": # First and first num
				inner = True
				num1 = dices[:i]
			elif nums1 and inner and char.isnumeric() and nums2 == False: # First and first num and last
				nums2 = True
				name2 = dices[:i]
			elif nums1 and inner and nums2 and char.isalpha(): # First and first num and last and last num
				num2 = dices[:i]
				num2 = num2.split(name2)[1]
				name2 = name2.split(num1)[1]
				num1 = num1.split(name1)[1]
				if len(babsB1) == len(babsB2): # If we're on an even item
					babsB1.append(name1) # Save it to the first array as data is saved
					babsB1.append(num1) # in a #1,#51,#2,#52... format
					babsG1.append(name2)
					babsG1.append(num2[:-2])
				else:
					rem = 1 if len(babsB1) < 20 else 2 # Remove either the last digit e.g 5005 > 500
					babsB2.append(name1) # or last two digits 50050 > 500 as there's no divider
					babsB2.append(num1) # between number of babies and rank
					babsG2.append(name2)
					babsG2.append(num2[:-rem])
				dices = dices[i:] # Avoid processing this section again
				break
				
	namesB.append(",".join([yr,*babsB1,*babsB2])) # Join first and last 50 babies together
	namesG.append(",".join([yr,*babsG1,*babsG2]))

with open("namesB.csv", "w") as names: # Write files
	names.write("\n".join(namesB))
with open("namesG.csv", "w") as names:
	names.write("\n".join(namesG))