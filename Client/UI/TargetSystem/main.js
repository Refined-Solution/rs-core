const debugMode = true;

const OPTION = new VirtualElement(null, 'div')
    .center()
    .width(150).height(25)
    .text('???')
    .css('text-align: center; font-size: 16px; color: black; font-weight: 900; font-family: "Arial", sans-serif; background-color: rgba(255, 255, 255, 0.26);')
    .transition(0.1)
    .observe('text', (el, text) => {
        el.text(text).build();
    })
    .onHoverIn((el) => {
        el.scale(1.1).build();
    })
    .onHoverOut((el) => {
        el.scale(1.0).build();
    })
;

UI
    .scale(1.0)
    .add('img')
        .center()
        .width(1920).height(1080)
        .set('src', "https://wallpapercave.com/wp/wp7644808.jpg")
    .done()
    .append(new CircleList(OPTION)).ref('option_list')
        .center()
        .css("background-color: rgba(255, 255, 255, 0.26); border: 1px solid rgb(255, 255, 255);")
    .done()
.build()
;

let options = [];
for (let i = 0; i < 8; i++) {
    options.push({
        text: `Option ${i + 1}`
    })
}

UI.find('option_list').addAll(options).build();

if (!debugMode) {

} else {

}