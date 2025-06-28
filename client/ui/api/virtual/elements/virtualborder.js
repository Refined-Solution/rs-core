class VirtualBorder extends VirtualElement {
    /**
     * @type {number}
     */
    _width = 1;

    /**
     * @type {string}
     */
    _css = "";

    /**
     * @type {{color: {r: number, g: number, b: number, a: number}, width: number, at: [[0]: number, [1]: number]}[]}
     */
    _accent = [];

    /**
     * @type {number}
     */
    _radius = 0;

    _radius2 = 0;
    _radius3 = 0;
    _radius4 = 0;

    /**
     * @type {string}
     */
    _color = "#000";

    /**
     * Creates a new virtual border element
     * @param {VirtualElement} parent 
     */
    constructor(parent) {
        super(parent, "div");
        this.classList.push("border");
    }

    /**
     * Sets the width of this border
     * @param {number} px
     * @returns {VirtualBorder} This border 
     */
    width(px) {
        this._width = px;
        return this;
    }

    /**
     * Adds a new accent to this border
     * @param {{r: number, g: number, b: number, a: number}|'string'} color 
     * @param {number} width 
     * @param {{[0]: number, [1]: number}} at 
     * @returns {VirtualBorder}
     */
    accent(color, width, at) {
        this._accent.push({color: color, width: width, at: at});
        return this;
    }

    /**
     * Sets the radius of this border
     * @param {number} px 
     * @param {number?} px2
     * @param {number?} px3
     * @param {number?} px4
     * @returns {VirtualBorder} This border
     */
    radius(px, px2, px3, px4) {
        if (px2 == null) px2 = px;
        if (px3 == null) px3 = px;
        if (px4 == null) px4 = px;
        this._radius = px;
        this._radius2 = px2;
        this._radius3 = px3;
        this._radius4 = px4;
        return this;
    }

    /**
     * Adds the given css to this border
     * @param {string} css 
     * @returns {VirtualBorder} This border
     */
    css(css) {
        this._css = css;
        return this;
    }

    /**
     * @param {string} color 
     * @returns {VirtualBorder} This border
     */
    color(color) {
        this._color = color;
        return this;
    }

    left = null;
    top = null;
    height = null;

    /**
     * Clones this element
     * @returns {VirtualBorder} A clone of this element
     */
    clone() {
        let clone = new VirtualBorder(this.parent);
        clone._width = this._width;
        clone.classList = [...this.classList];
        clone._css = this._css;
        clone._accent = [...this._accent];
        clone._radius = this._radius;
        clone._radius2 = this._radius2;
        clone._radius3 = this._radius3;
        clone._radius4 = this._radius4;
        clone._color = this._color;
        return clone;
    }

    /**
     * Builds this element
     * @returns {HTMLElement} This element
     */
    build() {
        if (!this.element) {
            this.element = document.createElement(this.tag);
            this.element.setAttribute("vid", this._VID);
            this.element.setAttribute("ref", this._ref);
        }
        
        let maskId = `mask-${Math.floor(Math.random() * 1000000)}`;
        let width = this._width * 2 + this.parent._style.width;
        let height = this._width * 2 + this.parent._style.height;

        let svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
        svg.setAttribute("width", width * SCALE);
        svg.setAttribute("height", height * SCALE);
        let mask = document.createElementNS("http://www.w3.org/2000/svg", "mask");
        mask.setAttribute("id", maskId);
        
        let rect = document.createElementNS("http://www.w3.org/2000/svg", "rect");
        rect.setAttribute("x", 0);
        rect.setAttribute("y", 0);
        rect.setAttribute("width", width * SCALE);
        rect.setAttribute("height", height * SCALE);
        rect.setAttribute("fill", "white");
        mask.appendChild(rect);

        let rad1InnerMod = this._width * (2 * this._radius / this.parent._style.width);
        let rad2InnerMod = this._width * (2 * this._radius2 / this.parent._style.width);
        let rad3InnerMod = this._width * (2 * this._radius3 / this.parent._style.width);
        let rad4InnerMod = this._width * (2 * this._radius4 / this.parent._style.width);

        let path = document.createElementNS("http://www.w3.org/2000/svg", "path");
        path.setAttribute("d", `
            M ${this._width * SCALE + this._radius * SCALE} ${this._width * SCALE}
            h ${this.parent._style.width * SCALE - this._radius * SCALE - this._radius2 * SCALE}
            q ${this._radius2 * SCALE - rad2InnerMod} ${rad2InnerMod} ${this._radius2 * SCALE} ${this._radius2 * SCALE}
            v ${this.parent._style.height * SCALE - this._radius2 * SCALE - this._radius3 * SCALE}
            q ${-rad3InnerMod} ${this._radius3 * SCALE - rad2InnerMod} ${-this._radius3 * SCALE} ${this._radius3 * SCALE}
            h ${-this.parent._style.width * SCALE + this._radius3 * SCALE + this._radius4 * SCALE}
            q ${-this._radius4 * SCALE + rad4InnerMod} ${-rad4InnerMod} ${-this._radius4 * SCALE} ${-this._radius4 * SCALE}
            v ${-this.parent._style.height * SCALE + this._radius4 * SCALE + this._radius * SCALE}
            q ${rad1InnerMod} ${-this._radius * SCALE + rad1InnerMod} ${this._radius * SCALE} ${-this._radius * SCALE}
            z 
        `);
        path.setAttribute("x", 0);
        path.setAttribute("y", 0);
        path.setAttribute("fill", "black");
        mask.append(path);
        
        svg.appendChild(mask);
        this.element.innerHTML = "";
        this.element.appendChild(svg);

        this.element.style.maskRepeat = "no-repeat";
        this.element.style.maskSize = "100%";

        this.element.style = this._css + `mask: url(#${maskId});`;
        this.classList.forEach(c => this.element.classList.add(c));
        this.element.style.setProperty("--LEFT", `${this.parent._style.left - this._width * 1/SCALE}px`);
        this.element.style.setProperty("--TOP", `${this.parent._style.top - this._width * 1/SCALE}px`);
        this.element.style.setProperty("--WIDTH", `${this.parent._style.width + this._width * 2}px`);
        this.element.style.setProperty("--HEIGHT", `${this.parent._style.height + this._width * 2}px`);
        this.element.style.setProperty("--FIX-HORIZONTAL", `${this.parent._style.fixLeft}%`);
        this.element.style.setProperty("--FIX-HORIZONTAL-BARE", `${this.parent._style.fixLeft / 100.0}`);
        this.element.style.setProperty("--FIX-VERTICAL", `${this.parent._style.fixTop}%`);
        this.element.style.setProperty("--FIX-VERTICAL-BARE", `${this.parent._style.fixTop / 100.0}`);

        this.element.style.setProperty("--RADIUS", `${this._radius + this._width}px`);
        this.element.style.setProperty("--RADIUS2", `${this._radius2 + this._width}px`);
        this.element.style.setProperty("--RADIUS3", `${this._radius3 + this._width}px`);
        this.element.style.setProperty("--RADIUS4", `${this._radius4 + this._width}px`);
        this.element.style.setProperty("--ROTATE", this._rotate + "deg");
        this.element.style.setProperty("--BWIDTH", `${this._width}px`);
        this.element.style.transition = `all ${this._transition}s`;

        let background = ``;
        for (let i = 0; i < this._accent.length; i++) {
            let accent = this._accent[i];
            let color = typeof accent.color == "string" ? accent.color : `rgba(${accent.color.r}, ${accent.color.g}, ${accent.color.b}, ${accent.color.a})`;
            let width = `${accent.width}%`;

            background += `radial-gradient(at ${accent.at[0]}% ${accent.at[1]}%, ${color}, transparent ${width}), `;
        }
        background += `${this._color}`;
        this.element.style.background = background;

        return [this.element, null];
    }
}