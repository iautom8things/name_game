const Hooks = {};

Hooks.UpdatedView = {
  updated() {

    const { hash } = this.el.dataset;
    console.log("called!", this.el, hash);
    window.location.hash = hash;
  },
};

export default Hooks;