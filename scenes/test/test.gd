# functionality for running tests
class_name Test
extends RefCounted

const indent: String = "	"

var _category: String

var ignore_set: Dictionary

func _init(category: String) -> void:
	self._category = category

var tests: Array[Callable]

func add(test: Callable) -> Test:
	tests.append(test)
	return self

func ignore() -> void:
	var method: Callable = tests.back()
	ignore_set.set(method.get_method(), "")
	
func run() -> void:
	var print_buff: Array[String]
	var success: int = 0
	for test in tests:
		var ignore_test: bool = ignore_set.has(test.get_method())
		var ignore_string: String = ""
		
		if ignore_test:
			ignore_string = "[color=none][IGNORED][/color]"
		
		var passed: bool = test.call()
		var status: String
		if not passed: 
			if not ignore_test:
				status = "[color=red]FAILED[/color]"
			else:
				status = "[color=none]FAILED[/color]"
		else: 
			if not ignore_test:
				status = "[color=green]PASSED[/color]"
				success += 1
			else:
				status = "[color=none]PASSED[/color]"
		
		var line: String = indent + status + ":" + ignore_string + " " + test.get_method()
		
		if not passed and not ignore_test:
			push_error("TEST FAILED: from [%s] called [%s]" % [_category, test.get_method()])
		print_buff.append(line)
		
	var all_passed: bool = success == (tests.size() - ignore_set.size())
	var color: String
	
	color = "green" if all_passed else "red"
	
	print_rich("[color=cyan]Testing:[/color] %s [color=%s](%d/%d)[/color] passed [%d IGNORED]" % [_category, color, success, tests.size(), ignore_set.size()])
	for line in print_buff:
		print_rich(line)
	#if not all_passed:
		# push_error("At least one test in %s failed, check testing ouput for details" % _category)
