const radToDeg = (rad) => rad * (180 / Math.PI);
const degToRad = (deg) => deg * (Math.PI / 180);

class CircleList extends VirtualElement {
    /**
     * @type {VirtualElement}
     */
    template = null;

    /**
     * @type {number} the radius of the circle in pixels
     */
    radius = 250;

    /**
     * @param {VirtualElement} template 
     * @param {string} direction
     */
    constructor(template, radius = 250) {
        super(null, "div");
        this.template = template;
        this.radius = radius;
        this.width(radius * 2);
        this.height(radius * 2);
        this.css("overflow: visible; border-radius: 50%;");
    }

    clone() {
        let clone = new CircleList(this.template, this.direction);
        clone.copyFrom(this);
        clone.template = this.template;
        clone.direction = this.direction;
        return clone;
    }

    /**
     * Adds a new element to this list
     * @param {Object.<string, any>} data 
     * @returns {CircleList}
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
     * @returns {CircleList}
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
     * @returns {CircleList} self
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
     * @returns {CircleList}
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
     * @returns {CircleList}
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
        let inc = 180;
        let offset = -45;
        let a = 0;
        let c = 4;

        for (let i = 0; i < this.children.length; i++) {
            let child = this.children[i];

            offset %= 360;

            console.log(inc, offset, a, i);
            let angle = degToRad(offset);
            let x = Math.cos(angle) * this.radius;
            let y = Math.sin(angle) * this.radius;
            child.left(x).top(y);
            if (a % 2 == 1) {
                offset += 90;
            }
            offset += 180;
            a++;
            if (a > c - 1) {
                a = 0;
                inc /= c;
                c *= 2;
                offset += inc;
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