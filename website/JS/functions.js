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

let months = [
	"January",
	"February",
	"March",
	"April",
	"May",
	"June",
	"July",
	"August",
	"September",
	"October",
	"November",
	"December",
];

function clearChart(chart) {
	chart.data.datasets = [];
	chart.options.scales.y.title = {
		display: false,
	};
	chart.update();
}

function setAxes(chart, xtitle, ytitle) {
	chart.options.scales.x.title = {
		display: true,
		text: xtitle,
	};

	chart.options.scales.y.title = {
		display: true,
		text: ytitle,
	};
	chart.update();
}

function addDataSeries(chart, output, property, label) {
	let data = [];
	let labels = [];

	output.forEach((x) => {
		let point = {};
		point.x = x.Year * 12 + x.Month;
		point.y = x[property];
		data.push(point);
		labels.push(`${months[x.Month]} ${x.Year}`);
	});

	chart.data = {
		labels: labels,
		datasets: [
			{
				label: label,
				pointRadius: 4,
				pointBackgroundColor: "rgba(173,216,230,1)",
				borderColor: "rgba(95,119,127,1)",
				data: data,
			},
		],
	};

	chart.update();
}


function getDefaultChartConfig() {
	return {
		type: "line",
		data: {
			datasets: [{}],
		},
		options: {
			plugins: {
				zoom: {
					pan: {
						enabled: true,
						mode: "x",
					},
					zoom: {
						wheel: {
							enabled: true,
						},
						pinch: {
							enabled: true,
						},
						mode: "x",
					},
				},
			},
		},

	}
}
