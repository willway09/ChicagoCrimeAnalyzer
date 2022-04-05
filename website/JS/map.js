let primaryColor = "#FF0000";
let secondaryColor = "#0000FF";
let clearColor = "#777";
let fillColor = "rgba(0,0,0,0)";

class ChicagoMap {

	async initializeMap() {
		let c = document.getElementById(this.div);

		let response = await fetch('Images/map.svg')
		let text = await response.text()
		c.innerHTML = text;

		let elements = c.children[0].children[1].children;

		Array.from(elements).forEach( (x) => {
			let colorString = x.style.stroke;
			colorString = colorString.replace("rgb(","");
			colorString = colorString.replace(")","");
			let index = colorString.split(",")[1] - 10;

			if(!isNaN(index) && index >= 0) {
				let instance = this.areaIndices[index - 1].length;
				let id = `commarea${index}_${instance}`;
				x.id = id;
				x.style.stroke = clearColor;
				x.style.fill = fillColor;
				this.areaIndices[index - 1].push(id);
				x.addEventListener("click", () => {
					console.log(index);
					this.areaClicked(index);
				});
			}

		});
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

	constructor(div, clickHandler) {
		this.div = div;
		this.clickHandler = clickHandler;
		this.areaIndices = [];
		this.borders = new Map()
		this.needsClearing = [];
		for(let i = 0; i < 77; i++) {
			this.areaIndices.push([]);
			this.borders[i+1] = [];
		}

		this.initializeMap();
		this.initializeBorders();

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

	areaClicked(areanum) {
		this.clearAll();
		this.borders[areanum].forEach( (x) => {
			this.setSecondary(x);
		});
		this.setPrimary(areanum);
		this.clickHandler(areanum);
	}
}
