/**
 * @type {number}
 */
SCALE = 1.0;

/**
 * @type {Object.<string, VirtualElement>}
 */
references = {};

let NVID = 1;

/**
 * @type {Object.<string, string>}
 */
const translations = {};

function translate(str) {
    if (typeof str != "string") {
        str = "" + str;
    }
    let lastStr = "";
    while (lastStr != str) {
        lastStr = str;
        for (let key in translations) {
            str = str.replaceAll("{" + key + "}", translations[key]);
        }
    }
    return str;
}

function setTranslation(key, value) {
    translations[key] = value;
}


/**
 * Can be used to build dynamic elements
 */
class VirtualElement {
    _VID = -1;

    _isClicked = false;

    /**
     * @type {VirtualElement}
     */
    parent = null;

    /**
     * @type {string}
     */
    tag = null;

    /**
     * @type {HTMLElement}
     */
    element = null;
    
    /**
     * @type {VirtualElement[]}
     */
    children = [];

    /**
     * @type {string[]}
     */
    classList = [];

    /**
     * @type {string}
     */
    _css = "";

    /**
     * @type {left: number, top: number, width: number, height: number, fixLeft: number, fixTop: number}
     */
    _style = {left: 0, top: 0, width: 0, height: 0, fixLeft: 0, fixTop: 0};

    /**
     * @type {VirtualBorder}
     */
    _border = null;

    /**
     * @type {number}
     */
    _transition = 0;

    _scale = [1.0, 1.0];

    /**
     * @type {Object.<string, function(VirtualElement, Event): void>}
     */
    _on = {};

    _fontSize = 12;

    _lineHeight = null;

    /**
     * @type {function(VirtualElement): void}
     */
    _hoverIn = (self) => {};

    /**
     * @type {function(VirtualElement): void}
     */
    _hoverOut = (self) => {};

    /**
     * @type {function(VirtualElement): void}
     */
    _click = (self) => {};

    /**
     * @param {function(VirtualElement) : void} self 
     */
    _created = (self) => {};

    /**
     * @type {boolean}
     */
    _clickPropagate = true;

    /**
     * @type {function(VirtualElement): void}
     */
    _down = (self) => {};

    /**
     * @type {function(VirtualElement): void} 
     */
    _up = (self) => {};

    /**
     * @type {Object.<string, any>}
     */
    _data = {};

    /**
     * @type {number}
     */
    _rotate = 0;

    /**
     * @type {{name: string, duration: number}?}
     */
    _animation = null;

    /**
     * @type {Object.<string, function(VirtualElement, any): void>}
     */
    _observers = {};

    /**
     * @type {string?}
     */
    _text = null;

    /**
     * @type {string}
     */
    _ref = null;

    /**
     * @type {string}
     */
    _display = "block";

    /**
     * @type {number}
     */
    _opacity = 1.0;

    _regular = [(ve) => {}, 1000000];

    /**
     * 
     * @param {VirtualElement} parent 
     * @param {string} tag 
     */
    constructor(parent, tag) {
        this.parent = parent;
        this.tag = tag;
        this._VID = NVID++;
        this.classList.push("scale");
    }

    /**
     * References this element with the given name
     * @param {string} name 
     * @returns {VirtualElement} This element
     */
    ref(name) {
        this._ref = name;
        references[name] = this;
        return this;
    }

    /**
     * Sets the left offset of this element
     * @param {number} left 
     * @returns {VirtualElement} This element
     */
    left(left) {
        left = Math.ceil(left);
        this._style.left = left;
        return this;
    }

    /**
     * Sets the top offset of this element
     * @param {number} top 
     * @returns {VirtualElement} This element
     */
    top(top) {
        top = Math.ceil(top);
        this._style.top = top;
        return this;
    }

    /**
     * Sets the width of this element
     * @param {number} width 
     * @returns {VirtualElement} This element
     */
    width(width) {
        width = Math.ceil(width);
        this._style.width = width;
        return this;
    }

    /**
     * Sets the height of this element
     * @param {number} height 
     * @returns {VirtualElement} This element
     */
    height(height) {
        height = Math.ceil(height);
        this._style.height = height;
        return this;
    }

    /**
     * Sets the anchor point of this element
     * @param {number} left (0-100)
     * @param {number} top (0-100)
     */
    fix(left, top) {
        this._style.fixLeft = left;
        this._style.fixTop = top;
        return this;
    }

    /**
     * Sets the transition duration of this element
     * @param {number} duration in seconds
     * @returns {VirtualElement} This element
     */
    transition(duration) {
        this._transition = duration;
        return this;
    }

    /**
     * Sets how this element should be displayed
     * @param {string} display 
     * @returns {VirtualElement} This element
     */
    display(display) {
        this._display = display;
        return this;
    }

    /**
     * Changes the scaling of this element
     * @param {number} x 
     * @param {number?} y if not given, y = x
     * @return {VirtualElement} This element 
     */
    scale(x, y) {
        if (y == null) y = x;
        this._scale = [x, y];
        return this;
    }

    /**
     * Rotates this element
     * @param {number} deg 
     * @returns {VirtualElement} This element
     */
    rotate(deg) {
        this._rotate = deg;
        return this;
    }

    /**
     * Sets the value of the given key
     * @param {string} key 
     * @param {any} value
     * @returns {VirtualElement} This element 
     */
    set(key, value) {
        this._data[key] = value;
        if (this._observers[key])
            this._observers[key](this, value);
        return this;
    }

    /**
     * Sets the data of this element
     * @param {{[key: string] any}} sets 
     * @returns {VirtualElement} This element
     */
    data(sets) {
        Object.keys(sets).forEach(key => {
            this.set(key, sets[key]);
        });
        return this;
    } 

    /**
     * Sets the inner text
     * @param {string?} text 
     * @returns {VirtualElement} This element
     */
    text(text, html = true) {
        if (text == null) text = "";
        text = text + "";
        this._text = text;
        if (this.element) {
            if (this.tag == 'input') this.element.value = translate(text);
            else if (html) this.element.innerHTML = translate(text);
            else this.element.textContent = translate(text);
        }
        return this;
    }

    /**
     * Returns the value of the given key
     * @param {string} key 
     * @returns {any} The value
     */
    get(key) {
        return this._data[key];
    }

    /**
     * Returns the value of the given element attribute
     * @param {string} key 
     * @returns {string} The value
     */
    getAttr(key) {
        return this.element.getAttribute(key);
    }

    /**
     * Returns the value of this element
     * @returns {string} The value
     */
    value() {
        if (!this.element) return null;
        return this.element.value;
    }

    /**
     * Simulates a click on this element
     * @returns {VirtualElement} This element
     */
    click() {
        this._click(this);
        return this;
    }

    /**
     * Sets the click callback of this element
     * @param {function(VirtualElement) : void} callback 
     * @returns {VirtualElement} This element
     */
    onClick(callback, propagate = false) {
        this._click = callback;
        this._clickPropagate = propagate;
        return this;
    }

    /**
     * Sets a callback for the given event
     * @param {string} event 
     * @param {function(VirtualElement, Event) : void} callback 
     * @returns {VirtualElement} This element
     */
    on(event, callback) {
        this._on[event] = callback;
        return this;
    }

    /**
     * Sets a callback that is called when this element is created.
     * The function will only be called the first time this element is created (not on every build)
     * @param {function(VirtualElement) : void} callback 
     * @returns {VirtualElement} This element
     */
    onCreated(callback) {
        this._created = callback;
        return this;
    }

    /**
     * Called when the mouse is pressed on this element
     * @param {function(VirtualElement)} callback 
     * @returns {VirtualElement}
     */
    onDown(callback) {
        this._down = callback;
        return this;
    }

    /**
     * Called when the mouse is released on this element
     * @param {function(VirtualElement)} callback 
     * @returns {VirtualElement}
     */
    onUp(callback) {
        this._up = callback;
        return this;
    }

    /**
     * Sets the hover in callback of this element
     * @param {function(VirtualElement) : void} callback 
     * @returns 
     */
    onHoverIn(callback) {
        this._hoverIn = callback;
        return this;
    }

        /**
     * Sets the hover out callback of this element
     * @param {function(VirtualElement) : void} callback 
     * @returns 
     */
    onHoverOut(callback) {
        this._hoverOut = callback;
        return this;
    }

    /**
     * Anchors this element to the center of the screen
     * @returns {VirtualElement} This element
     */
    center() {
        this._style.fixLeft = 50;
        this._style.fixTop = 50;
        return this;
    }

    /**
     * Adds css to this element
     * @param {string} css 
     * @returns {VirtualElement} This element
     */
    css(css, ov = false) {
        if (ov) this._css = "";
        this._css += css;
        return this;
    }

    /**
     * Sets the opacity of this element
     * @param {number} opacity 
     * @returns {VirtualElement} This element
     */
    opacity(opacity) {
        this._opacity = Math.min(0.99, opacity);
        return this;
    }

    /**
     * Adds a border to this element
     * @returns {VirtualBorder} The border
     */
    border() {
        if (this._border) return this._border;
        this._border = new VirtualBorder(this);
        return this._border;
    }

    /**
     * Sets the name of the animation and its duration in seconds
     * @param {string} name 
     * @param {number} duration
     * @returns {VirtualElement} This element 
     */
    animation(name, duration) {
        this._animation = {name: name, duration: duration};
        return this;
    }

    /**
     * Returns the first child with a matching reference name
     * @param {string} str the reference name of the child
     * @returns {VirtualElement?} The child element
     */
    find(str) {
        if (this._ref == str) return this;
        for (let child of this.children) {
            let found = child.find(str);
            if (found) return found;
        }
        return null;
    }

    /**
     * Returns all elements with the given reference name
     * @param {string} str
     * @returns {VirtualElement[]} The elements 
     */
    findAll(str) {
        let found = [];
        if (this._ref == str) found.push(this);
        for (let child of this.children) {
            found = found.concat(child.findAll(str));
        }
        return found;
    }

    /**
     * Deletes this element
     * @returns {VirtualElement} This element
     */
    delete() {
        if (this.element) this.element.remove();
        if (this._border) this._border.delete();
        if (this.parent) {
            this.parent.children.splice(this.parent.children.indexOf(this), 1);
            this.parent.build();
        }
        return this;
    }

    /**
     * @param {VirtualElement} other 
     * @returns {VirtualElement}
     */
    copyFrom(other) {
        this.classList = [...other.classList];
        this._css = "" + other._css;
        this._style = {...other._style};
        this._transition = other._transition;
        this._scale = [...other._scale];
        this._hoverIn = other._hoverIn;
        this._hoverOut = other._hoverOut;
        this._click = other._click;
        this._rotate = other._rotate;
        this._animation = other._animation;
        this._observers = {...other._observers};
        this._text = other._text;
        this._down = other._down;
        this._up = other._up;
        this._display = other._display;
        this._opacity = other._opacity;
        this._clickPropagate = other._clickPropagate;
        this._created = other._created;
        this._on = {...other._on};
        this._regular = [...other._regular];
        this._fontSize = other._fontSize;
        this._lineHeight = other._lineHeight;
        if (other._ref != null) this.ref(other._ref);
        if (other._border) {
            this._border = other._border.clone();
            this._border.parent = this;
        }
        other.children.forEach(child => {
            let clone = child.clone();
            clone.parent = this;
            this.children.push(clone);
        });
        Object.keys(other._data).forEach(key => {
            this.set(key, other._data[key]);
        });
        return this;
    }

    /**
     * Returns a clone of this virtual element
     * @returns {VirtualElement} The clone
     */
    clone() {
        let clone = new VirtualElement(null, this.tag);
        clone.copyFrom(this);
        return clone;
    }

    /**
     * Adds a child to this virtual element
     * @param {string} tag 
     * @returns {VirtualElement} The child
     */
    add(tag) {
        let child = new VirtualElement(this, tag);
        this.children.push(child);
        return child;
    }

    /**
     * Adds the given elemnt as a child to this virtual element
     * @param {VirtualElement} child 
     */
    append(child) {
        child = child.clone();
        this.children.push(child);
        child.parent = this;
        return child;
    }

    /**
     * Returns the parent element of this virtual element
     * @returns {VirtualElement} The parent element
     */
    done() {
        return this.parent;
    }

    /**
     * Observes the given key in the data of this element
     * @param {string} key
     * @param {function(VirtualElement, any): void} cb
     * @returns {VirtualElement} This element 
     */
    observe(key, cb) {
        this._observers[key] = cb;
        if (this._data[key])
            cb(this, this._data[key]);
        return this;
    }

    /**
     * Sets a function to call regularly when this element has been added
     * @param {function(VirtualElement) : void} callback
     * @param {number} interval in milliseconds
     * @returns {VirtualElement} This element 
     */
    regular(callback, interval = 0) {
        this._regular = [callback, interval];
        return this;
    }

    /**
     * Sets the font size for this element
     * @param {number} size
     * @returns {VirtualElement} This element 
     */
    fontSize(size) {
        this._fontSize = size;
        return this;
    }

    /**
     * Sets the line height for this element
     * @param {number} size 
     * @returns {VirtualElement} This element
     */
    lineHeight(size) {
        this._lineHeight = size;
        return this;
    }

    /**
     * Builds the base of this virtual element.
     * This won't build any children
     * @returns {VirtualElement}
     */
    buildBase() {
        let isNew = false;
        if (!this.element) {
            this.element = document.createElement(this.tag);
            this.element.setAttribute("vid", this._VID);
            this.element.setAttribute("ref", this._ref);
            isNew = true;
        }

        for (let className of this.classList)
            this.element.classList.add(className);

        if (this.tag == 'input') this.element.value = translate(this._text);
        else if (this._text != null)
            this.element.innerHTML = translate(this._text);

        this.element.style = this._css;
        this.element.style.transition = `all ${this._transition}s`;

        this.element.style.setProperty("--SCALE-X", this._scale[0]);
        this.element.style.setProperty("--SCALE-Y", this._scale[1]);
        this.element.style.setProperty("--ROTATE", this._rotate + "deg");
        this.element.style.setProperty("display", this._display);
        this.element.style.setProperty("opacity", this._opacity);
        if (this._animation)
            this.element.style.setProperty("animation", `${this._animation.name} ${this._animation.duration}s`);

        if (this._style.left)
            this.element.style.setProperty("--LEFT", this._style.left + "px");
        if (this._style.top)
            this.element.style.setProperty("--TOP", this._style.top + "px");
        if (this._style.width)
            this.element.style.setProperty("--WIDTH", this._style.width + "px");
        if (this._style.height)
            this.element.style.setProperty("--HEIGHT", this._style.height + "px");
        if (this._style.fixLeft) {
            this.element.style.setProperty("--FIX-HORIZONTAL", this._style.fixLeft + "%");
            this.element.style.setProperty("--FIX-HORIZONTAL-BARE", this._style.fixLeft / 100.0);
        }
        if (this._style.fixTop) {
            this.element.style.setProperty("--FIX-VERTICAL", this._style.fixTop + "%");
            this.element.style.setProperty("--FIX-VERTICAL-BARE", this._style.fixTop / 100.0);
        }

        this.element.style.setProperty("--FSIZE", this._fontSize + "px");

        if (this._lineHeight) this.element.style.setProperty("--LHEIGHT", this._lineHeight + "px");

        let borderElem = null;
        if (this._border) {
            [borderElem] = this._border.build();
            borderElem.style.transition = `all ${this._transition}s`;
            borderElem.style.setProperty("--SCALE-X", this._scale[0]);
            borderElem.style.setProperty("--SCALE-Y", this._scale[1]);
            borderElem.style.setProperty("--ROTATE", this._rotate + "deg");
            borderElem.style.setProperty("display", this._display);
            borderElem.style.setProperty("opacity", this._opacity);
            borderElem.style.transition = `all ${this._transition}s`;
            if (this._animation)
                borderElem.style.setProperty("animation", `${this._animation.name} ${this._animation.duration}s`);
            this.element.style.setProperty("--RADIUS", `${this._border._radius}px`);
            this.element.style.setProperty("--RADIUS2", `${this._border._radius2}px`);
            this.element.style.setProperty("--RADIUS3", `${this._border._radius3}px`);
            this.element.style.setProperty("--RADIUS4", `${this._border._radius4}px`);
        }

        this.element.onmouseover = (t, e) => {
            this.set('hovered', true);
            this._hoverIn(this);
        }
        this.element.onmouseout = (t, e) => {
            for (let child of this.children) {
                if (child.get('hovered')) {
                    return;
                }
            }
            if (this._isClicked) {
                this._isClicked = false;
                this._up(this);
            }
            this._hoverOut(this);
        }
        this.element.onmousedown = () => {
            this._isClicked = true;
            this._down(this);
        }
        this.element.onmouseup = () => {
            this._isClicked = false;
            this._up(this);
        }
        this.element.onclick = (event) => {
            if (!this._clickPropagate) event.stopPropagation();
            this._click(this);
        }
        
        for (let event in this._on) {
            this.element.addEventListener(event, (e) => {
                this._on[event](this, e);
            });
        }

        for (let key in this._data)
            this.element.setAttribute(`${key}`, this._data[key]);

        if (isNew) {
            setTimeout(() => { this._created(this); }, 0);
            setInterval(() => {
                this._regular[0](this);
            }, this._regular[1]);
        }
    }

    /**
     * Builds the HTML element for this virtual element
     * @returns {HTMLElement} The HTML element
     */
    build( recursive = true ) {
        this.buildBase();
        if (recursive) {
            for (let child of this.children) {
                let [c1, c2] = child.build();
                let children = this.element.children;
                let containsC1 = false;
                let containsC2 = false;
                for (let i = 0; i < children.length; i++) {
                    if (children[i] == c1) containsC1 = true;
                    if (children[i] == c2) containsC2 = true;
                }

                if (c1 && !containsC1)
                    this.element.appendChild(c1);
                if (c2 && !containsC2)
                    this.element.appendChild(c2);
            }
        }

        let borderElem = null;
        if (this._border) borderElem = this._border.element;
        return [borderElem, this.element];
    }
}

/**
 * @type {VirtualElement}
 */
UI = new VirtualElement(null, null);
UI.css("width: 100%; height: 100%;");

/**
 * Sets the scaling of the UI
 * @param {number} scale 
 * @returns {VirtualElement}
 */
UI.scale = function(scale) {
    SCALE = scale;
    UI.css(`--SCALE: ${scale};`);
    return this;
}
UI.element = document.body;

/**
 * Creates a new element of the given type
 * @param {string} type 
 * @returns {VirtualElement}
 */
function element(type) {
    return new VirtualElement(null, type);
}

/**
 * Returns the element with the given name
 * @param {string} name 
 * @returns {VirtualElement}
 */
function getRefrence(name) {
    return references[name];
}
