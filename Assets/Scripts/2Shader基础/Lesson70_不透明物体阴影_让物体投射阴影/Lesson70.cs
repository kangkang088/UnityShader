using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lesson70 : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        #region ֪ʶ��һ ����Fallback������
        //�����½�һ��������
        //�����Shader����Ϊ����֮ǰ��д�Ķ��ֹ�Դ�ۺ�ʵ��Shader
        //Lesson64_ForwardLighting

        //�����ò�����ֵ���ϴ��������ʹ��
        //���ǻᷢ�ָ������岻��Ͷ����ӰҲ���ٽ�����Ӱ
        //1.��Ͷ����Ӱ��ԭ��
        //  ��Shader��û��LightModeΪShaderCaster��Pass���޷������Դ����Ӱӳ������ļ���
        //2.��������Ӱ��ԭ��
        //  ��Shader��û�ж���Ӱӳ�����������в�����û�н�����Ӱ�����ɫ����

        //����֮ǰѧϰ����֪ʶʱ�ᵽ��
        //Unity��Ѱ��LightModeΪShaderCaster��Pass�����д��������Shaderû�и�Pass
        //������FallBackָ����Shader��Ѱ�ң�ֱ���ҵ�Ϊֹ

        //���������ڸ�Shader ������FallBack "Specular"
        //������ø�������Ͷ����Ӱ
        #endregion

        #region ֪ʶ��� ������Ͷ����Ӱ
        //��������������Ͷ����Ӱ�Ĺؼ����ǣ�
        //1. ��Ҫʵ�� LightMode(�ƹ�ģʽ) Ϊ ShadowCaster(��ӰͶ��) �� Pass(��Ⱦͨ��)
        //   ������������ܲ��뵽��Դ����Ӱӳ�����������

        //2. һ������ָ�һ�������ļ��������ؼ���
        //  ����ָ�
        //  #pragma multi_compile_shadowcaster
        //  �ñ���ָ��ʱ����Unity���������ɶ����ɫ������
        //  ����֧�ֲ�ͬ���͵���Ӱ��SM��SSSM�ȵȣ�
        //  ����ȷ����ɫ���ܹ������п��ܵ���ӰͶ��ģʽ����ȷ��Ⱦ

        //  �����ļ���
        //  #include "UnityCG.cginc"
        //  ���а����˹ؼ�����Ӱ������صĺ�

        //  �����ؼ���:
        //  2-1.V2F_SHADOW_CASTER
        //    ���㵽ƬԪ��ɫ����ӰͶ��ṹ�����ݺ�
        //    ����궨����һЩ��׼�ĳ�Ա����
        //    ��Щ������������ӰͶ��·���д��ݶ������ݵ�ƬԪ��ɫ��
        //    ������Ҫ�ڽṹ����ʹ��
        //  2-2.TRANSFER_SHADOW_CASTER_NORMALOFFSET
        //    ת����ӰͶ��������ƫ�ƺ�
        //    �����ڶ�����ɫ���м���ʹ�����ӰͶ������ı���
        //    ��Ҫ����
        //    2-2-1.������ռ�Ķ���λ��ת��Ϊ�ü��ռ��λ��
        //    2-2-2.���Ƿ���ƫ�ƣ��Լ�����Ӱʧ�����⣬�������ڴ�������Ӱʱ
        //    2-2-3.���ݶ����ͶӰ�ռ�λ�ã����ں�������Ӱ����
        //    ������Ҫ�ڶ�����ɫ����ʹ��
        //  2-3.SHADOW_CASTER_FRAGMENT
        //    ��ӰͶ��ƬԪ��
        //    �����ֵд�뵽��Ӱӳ��������
        //    ������Ҫ��ƬԪ��ɫ����ʹ��

        //3.������Щ������Shader��ʵ�ִ���
        #endregion

        #region ֪ʶ���� ����
        //����Ͷ����Ӱ��صĴ����Ϊͨ��
        //��˽����Ҳ����Լ�ȥʵ�����Shader����
        //ֱ��ͨ��FallBack����Unity��Ĭ��Shader�е���ش��뼴��
        #endregion
    }

    // Update is called once per frame
    void Update()
    {

    }
}
