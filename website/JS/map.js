let primaryColor = "#ACD7E6";
let secondaryColor = "#E6BAAC";
let clearColor = "#777";
let fillColor = "rgba(0,0,0,0)";

class ChicagoMap {
	async initializeMap(initialValue) {

		//If not Border mode, asynchronously load
		if(this.mode != "Border") {
			this.initializeBorders();
		}

		let c = document.getElementById(this.div);

		let response = await fetch('Images/map.svg')
		let text = await response.text()
		c.innerHTML = text;

		let elements = c.children[0].children[1].children;

		Array.from(elements).forEach( (x) => {
			let colorString = x.style.stroke;
			colorString = colorString.replace("rgb(","");
			colorString = colorString.replace(")","");
			let index = colorString.split(",")[0] - 10;
			let check = colorString.split(", ")[1];

			if(!isNaN(index) && index >= 0 && check == 50) {
				let instance = this.areaIndices[index - 1].length;
				let id = `commarea${index}_${instance}`;
				x.id = id;
				x.style.stroke = clearColor;
				x.style.fill = fillColor;
				this.areaIndices[index - 1].push(id);
				if(this.mode != "LatLon") {
					x.addEventListener("click", () => {
						this.setAreaActive(index);
					});
				}
			}
		});

		if(this.mode == "LatLon") {
			this.longitude = -87.732;
			this.latitude = 41.83375;


			let base = c.children[0].children[1];

			let size = c.children[0].width.animVal.valueInSpecifiedUnits;

			let centerpos = size / 2;

			let point = document.createElementNS("http://www.w3.org/2000/svg", "circle");
			point.setAttributeNS(null, "cx", centerpos);
			point.setAttributeNS(null, "cy", centerpos);
			point.setAttributeNS(null, "r", 4);
			point.setAttributeNS(null, "style", "fill: rgb(191,191,191); stroke: rgb(127,127,127); stroke-width: 2;");
			point.id = "centerpoint";
			base.appendChild(point);

			let vline = document.createElementNS("http://www.w3.org/2000/svg", "line");
			vline.setAttributeNS(null, "x1", centerpos);
			vline.setAttributeNS(null, "y1", 0);
			vline.setAttributeNS(null, "x2", centerpos);
			vline.setAttributeNS(null, "y2", size);
			vline.setAttributeNS(null, "style", "stroke:rgb(255,255,255); stroke-width:.5");
			vline.id = "vline";
			base.appendChild(vline);

			let hline = document.createElementNS("http://www.w3.org/2000/svg", "line");
			hline.setAttributeNS(null, "x1", 0);
			hline.setAttributeNS(null, "y1", centerpos);
			hline.setAttributeNS(null, "x2", size);
			hline.setAttributeNS(null, "y2", centerpos);
			hline.setAttributeNS(null, "style", "stroke:rgb(255,255,255); stroke-width:.5");
			hline.id = "hline";
			base.appendChild(hline);


			let lat = document.createElementNS("http://www.w3.org/2000/svg", "text");
			lat.setAttributeNS(null, "x", 10);
			lat.setAttributeNS(null, "y", 465);
			lat.setAttributeNS(null, "fill", "#e8e6e3");
			lat.setAttributeNS(null, "font-size", 10);
			lat.id = "maplat";
			lat.innerHTML = `Latitude: ${this.latitude}`;
			base.appendChild(lat);

			let lon = document.createElementNS("http://www.w3.org/2000/svg", "text");
			lon.setAttributeNS(null, "x", 10);
			lon.setAttributeNS(null, "y", 450);
			lon.setAttributeNS(null, "fill", "#e8e6e3");
			lon.setAttributeNS(null, "font-size", 10);
			lon.id = "maplon";
			lon.innerHTML = `Longitude: ${this.longitude}`;
			base.appendChild(lon);

			let clickrect = base.children[1].cloneNode();
			clickrect.style.fill= "rgba(0, 0, 0, 0)";
			base.appendChild(clickrect);

			let scale = c.children[0].width.animVal.valueInSpecifiedUnits / c.children[0].width.animVal.value;

			clickrect.addEventListener("click", (e) => {

				/* Taken from map.R in data folder:
				[1] "Minimum X: -87.9399"
				[1] "Maximum X: -87.5241"
				[1] "Minimum Y: 41.6445"
				[1] "Maximum Y: 42.023"

				SVG Point	Coordinate
				X: 0		Lon: -87.9399
				X: 503		Lon: -87.5241
				Y: 25.429688	Lat: 41.6445
				Y: 478.570312	Lon: 42.023
				*/
				let x = e.offsetX * scale;
				let y = e.offsetY * scale;

				this.longitude = range(0, 503, -87.9399, -87.5241, x);
				this.latitude = range(25.429688, 478.570312, 42.023, 41.6445, y);

				point.setAttributeNS(null, "cx", x);
				point.setAttributeNS(null, "cy", y);

				vline.setAttributeNS(null, "x1", x);
				vline.setAttributeNS(null, "x2", x);

				hline.setAttributeNS(null, "y1", y);
				hline.setAttributeNS(null, "y2", y);

				lat.innerHTML = `Latitude: ${Math.round(this.latitude * 10000) / 10000}`;
				lon.innerHTML = `Longitude: ${Math.round(this.longitude * 10000) / 10000}`;
			});
		}

		//If Border mode, need info now, so wait and load
		if(this.mode == "Border") {
			await this.initializeBorders();
		 }

		if(initialValue != 0 && this.mode != "LatLon") {
			this.setAreaActive(initialValue);
		}
	}

	async initializeBorders() {
		let response = await fetch('/api/borders')
		let borders = await response.json()
		borders.forEach( (x) => {
			if(x.From != x.To) {
				this.borders[x.From].push(x.To);
			}
		});
	}

	constructor(div, clickHandler, mode, initialValue = 0) {
		this.div = div;
		this.clickHandler = clickHandler;
		this.mode = mode;
		this.latitude = 0;
		this.longitude = 0;
		this.areaIndices = [];
		this.borders = new Map()
		this.needsClearing = [];
		for(let i = 0; i < 77; i++) {
			this.areaIndices.push([]);
			this.borders[i+1] = [];
		}

		this.initializeMap(initialValue);
	}

	setColor(commarea, color, bold=true, flag=true) {
		let indices = this.areaIndices[commarea - 1];

		let reInsert = document.getElementById(this.div).children[0].children[1];

		indices.forEach( (x) => {
			let segment = document.getElementById(x);
			segment.remove();
			segment.style.stroke = color;	
			if(bold) {
				segment.style.strokeWidth=1.5
			} else {
				segment.style.strokeWidth=.75
			}

			reInsert.appendChild(segment);
			if(flag) {
				this.needsClearing.push(commarea);
			}
		});
	}

	setPrimary(commarea) {
		this.setColor(commarea, primaryColor);
	}

	setSecondary(commarea) {
		this.setColor(commarea, secondaryColor);
	}

	clear(commarea) {
		this.setColor(commarea, clearColor, false, false);
	}

	clearAll() {
		this.needsClearing.forEach( x => this.clear(x));
	}

	setAreaActive(areanum) {
		this.clearAll();
		if(this.mode == "Border") {
			this.borders[areanum].forEach( (x) => {
				this.setSecondary(x);
			});
		}
		this.setPrimary(areanum);
		this.clickHandler(areanum);
	}
}
