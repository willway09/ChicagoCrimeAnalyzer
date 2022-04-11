function monthIdxToMonth(monthIdx) {
	let month = {
		year: Math.floor(monthIdx / 12),
		month: (monthIdx % 12) + 1
	};
	return month;
}

function monthToMonthIdx(month) {
	return 12 * month.year + (month.month - 1);

}

function monthToString(month) {
	let yearStr = `${month.year}`;
	let monthStr = `${month.month}`
	if(monthStr.length == 1) {
		monthStr = "0" + monthStr;
	}
	return yearStr + "-" + monthStr;
}

function stringToMonth(str) {
	nums = str.split("-");
	let month = {
		year: parseInt(nums[0]),
		month: parseInt(nums[1])
	}
	return month;
}
