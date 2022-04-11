let primaryColor = "#FF0000";
let secondaryColor = "#0000FF";
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
				x.addEventListener("click", () => {
					this.setAreaActive(index);
				});
			}

		});

		//If Border mode, need info now, so wait and load
		if(this.mode == "Border") {
			await this.initializeBorders();
		 }

		if(initialValue != 0) {
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
		this.areaIndices = [];
		this.borders = new Map()
		this.needsClearing = [];
		for(let i = 0; i < 77; i++) {
			this.areaIndices.push([]);
			this.borders[i+1] = [];
		}

		this.initializeMap(initialValue);
	}

	setColor(commarea, color, flag=true) {
		let indices = this.areaIndices[commarea - 1];

		let reInsert = document.getElementById(this.div).children[0].children[1];

		indices.forEach( (x) => {
			let segment = document.getElementById(x);
			segment.remove();
			segment.style.stroke = color;	
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
		this.setColor(commarea, clearColor, false);
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
