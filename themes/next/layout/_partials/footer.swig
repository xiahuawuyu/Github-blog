我被看了 <span id="busuanzi_value_site_pv"></span> 次~您是第<span id="busuanzi_value_site_uv"></span>个小伙伴
        <script type="text/javascript">
        var cnzz_protocol = (("https:" == document.location.protocol) ? " https://" : " http://");
        document.write(unescape("%3Cspan style='visibility:hidden;' id='cnzz_stat_icon_1255866986'%3E%3C/span%3E%3Cscript src='" + cnzz_protocol + "s11.cnzz.com/z_stat.php%3Fid%3D1255866986%26show%3Dpic' type='text/javascript'%3E%3C/script%3E"));
        </script>
<div class="copyright">
  {% set current = date(Date.now(), "YYYY") %}
  &copy; &nbsp; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  {{ current }}
  <span class="with-love">
    <i class="icon-heart"></i>
  </span>
  <span class="author">{{ config.author }}</span>
</div>

<div class="powered-by" style="visibility:hidden;">
  {{ __('footer.powered', '<a class="theme-link" href="http://hexo.io">Hexo</a>') }}
</div>

<div class="theme-info" style="visibility:hidden;">
  {{ __('footer.theme') }} -
  <a class="theme-link" href="https://github.com/iissnan/hexo-theme-next">
    NexT{% if theme.scheme %}.{{ theme.scheme }}{% endif %}
  </a>
</div> 

{% block footer %}{% endblock %}
