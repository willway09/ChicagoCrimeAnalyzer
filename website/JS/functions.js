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

//Adapted from https://stackoverflow.com/questions/17242144/javascript-convert-hsb-hsv-color-to-rgb-accurately
function HSVtoRGB(h, s, v) {
	var r, g, b, i, f, p, q, t;

	i = Math.floor(h * 6);
	f = h * 6 - i;
	p = v * (1 - s);
	q = v * (1 - f * s);
	t = v * (1 - (1 - f) * s);
	switch (i % 6) {
		case 0: r = v, g = t, b = p; break;
		case 1: r = q, g = v, b = p; break;
		case 2: r = p, g = v, b = t; break;
		case 3: r = p, g = q, b = v; break;
		case 4: r = t, g = p, b = v; break;
		case 5: r = v, g = p, b = q; break;
	}

	return `rgb(${Math.round(r * 255)}, ${Math.round(g * 255)}, ${Math.round(b * 255)})`;
}


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

let order = [
	0,
	5,
	7,
	6,
	1,
	2,
	3,
	8,
	9,
	4,
];

let colors = [];

order.forEach( (x) => {
	colors.push(
		{
			point: HSVtoRGB(195 / 360 + x / 10., .25, .90),
			line: HSVtoRGB(195 / 360 + x / 10., .25, .50)
		}
	);
});

console.log(colors);

function addDataSeries(chart, output, property, label, number=0, byYear=false) {
	let data = [];
	let labels = [];

	output.forEach((x) => {
		if(byYear) {
			let point = {};
			point.x = x.Year
			point.y = x[property];
			data.push(point);
			labels.push(`${x.Year}`);
		} else {
			let point = {};
			point.x = x.Year * 12 + x.Month;
			point.y = x[property];
			data.push(point);
			labels.push(`${months[x.Month]} ${x.Year}`);
		}
	});

	if(number == 0) {
		chart.data = {
			labels: labels,
			datasets: [
				{
					label: label,
					pointRadius: 4,
					pointBackgroundColor: colors[number].point,
					borderColor: colors[number].line,
					data: data,
				},
			],
		};
	} else {
		chart.data.datasets.push(
			{
				label: label,
				pointRadius: 4,
				pointBackgroundColor: colors[number].point,
				borderColor: colors[number].line,
				data: data,
			}
		);
	}


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

//Taken from https://www.trysmudford.com/blog/linear-interpolation-functions/, slightly modified
const lerp = (x, y, a) => x * (1 - a) + y * a;
const invlerp = (x, y, a) => (a - x) / (y - x);
const range = (x1, y1, x2, y2, a) => lerp(x2, y2, invlerp(x1, y1, a));
