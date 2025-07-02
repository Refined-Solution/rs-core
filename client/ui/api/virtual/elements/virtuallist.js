class VirtualList extends VirtualElement {
    /**
     * @type {VirtualElement}
     */
    template = null;

    /**
     * @type {string}
     */
    direction = "vertical";

    /**
     * @type {boolean}
     */
    corssfill = true;

    /**
     * @param {VirtualElement} template 
     * @param {string} direction
     */
    constructor(template, direction = "vertical", corssfill = true) {
        super(null, "div");
        this.template = template;
        this.direction = direction;
        this.corssfill = corssfill;
        this.css("overflow: hidden;");
        if (direction === "horizontal")
            this.css("overflow-x: auto;");
        else
            this.css("overflow-y: auto;");
    }

    clone() {
        let clone = new VirtualList(this.template, this.direction);
        clone.copyFrom(this);
        clone.template = this.template;
        clone.direction = this.direction;
        return clone;
    }

    /**
     * Adds a new element to this list
     * @param {Object.<string, any>} data 
     * @returns {VirtualList}
     */
    add(data) {
        this.append(this.template)
            .data(data);
        return this;
    }

    /**
     * Adds all the entries from the given array and modifies them with the given function
     * @param {Object.<string, any>[]} list 
     * @param {function(Object.<string, any>) : Object.<string, any>?} modify 
     * @returns {VirtualList}
     */
    addAll(list, modify) {
        for (let i = 0; i < list.length; i++) {
            let data = list[i];
            if (modify) {
                data.arrayIndex = i;
                data = modify(data);
            }
            if (data) this.add(data);
        }
        return this;
    }

    /**
     * Clears this list of all elements
     * @returns {VirtualList} self
     */
    clear() {
        this.children = [];
        if (this.element)
            this.element.innerHTML = "";
        return this;
    }

    /**
     * Returns the element at the given index
     * @param {number} index 
     * @returns {VirtualList}
     */
    remove(index) {
        this.children.splice(index, 1);
        return this;
    }

    /**
     * Returns all the indexes of the elements that match the given data
     * @param {Object.<string, any>} data 
     */
    index(data) {
        let indexes = [];
        for (let i = 0; i < this.children.length; i++) {
            let child = this.children[i];
            let match = true;
            for (let key in data) {
                if (child._data[key] !== data[key]) {
                    match = false;
                    break;
                }
            }
            if (match) indexes.push(i);
        }
        return indexes;
    }

    /**
     * Removes an element that matches the given data
     * @param {Object.<string, any>} data 
     * @returns {VirtualList}
     */
    removeByData(data) {
        this.children = this.children.filter(child => {
            for (let key in data) {
                if (child._data[key] != data[key]) {
                    return true;
                }
            }
            return false;
        });
        return this;
    }

    /**
     * Builds the HTML element for this virtual element
    * @returns {HTMLElement} The HTML element
    */
    build() {
        this.buildBase();
        for (let i = 0; i < this.children.length; i++) {
            let child = this.children[i];

            let maxH = 1;
            let maxW = 1;
            if (child) {
                maxH = Math.floor(this._style.height / (this.template._style.height + this.template._style.top));
                maxW = Math.floor(this._style.width / (this.template._style.width + this.template._style.left));
            }

            if (!this.corssfill) {
                if (this.direction == 'horizontal') {
                    maxH = 1;
                } else {
                    maxW = 1;
                }
            }

            if (this.direction == 'horizontal') {
                let row = i % maxH;
                let col = Math.floor(i / maxH);
                child.left(col * (this.template._style.width + this.template._style.left) + this.template._style.left);
                child.top(row * (this.template._style.height + this.template._style.top) + this.template._style.top);
            } else {
                let col = i % maxW;
                let row = Math.floor(i / maxW);
                child.left(col * (this.template._style.width + this.template._style.left) + this.template._style.left);
                child.top(row * (this.template._style.height + this.template._style.top) + this.template._style.top);
            }

            let [borderElem, elem] = child.build();
            if (borderElem) this.element.appendChild(borderElem);
            this.element.appendChild(elem);
        }

        let borderElem = null;
        if (this._border) {
            borderElem = this._border.element;
        }
        return [borderElem, this.element];
    }

}